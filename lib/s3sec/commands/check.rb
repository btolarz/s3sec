# frozen_string_literal: true

require_relative '../command'
require_relative '../services/open_buckets'
require_relative '../services/public_files'
require 'tty-spinner'
require 'tty-tree'
require 'tty-progressbar'

module S3sec
  module Commands
    class Check < S3sec::Command
      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        output.puts 'Wrong credentials' && return unless validate_credentials

        extentions = choose_extentions
        buckets = get_buckets
        tree, data = prepare_data(buckets, get_files(buckets, extentions))

        render_results(output, tree, data)
      end

      private

      def validate_credentials
        ![config.fetch(:AWS_ACCESS_KEY_ID), config.fetch(:AWS_SECRET_ACCESS_KEY)].any?(&:nil?)
      end

      def choose_extentions
        prompt.multi_select("Extentions") do |menu|
          menu.default 1, 2, 3, 4
          %w(csv xls xlsx dump pdf jpg txt).each do |e|
            menu.choice e
          end
        end
      end

      def get_buckets
        spinner = TTY::Spinner.new("[:spinner] Looking for buckets ...", format: :pulse_2)
        spinner.auto_spin

        buckets = OpenBuckets.call(
          access_key: config.fetch(:AWS_ACCESS_KEY_ID),
          secret: config.fetch(:AWS_SECRET_ACCESS_KEY)
        )

        spinner.stop('Done!')
        buckets
      end

      def get_files(buckets, extentions)
        bars = TTY::ProgressBar::Multi.new("[:bar] Looking for public files ...")

        buckets.reduce([]) do |arr, bucket|
          state = bucket.public ? pastel.yellow('public') : pastel.green('private')
          bar = bars.register "[:bar] #{bucket.name} #{state}", total: bucket.keys.size

          if bucket.keys.any?
            files = PublicFiles.call(bucket, extentions, -> { bar.advance })
            arr.concat(files)
          end

          arr
        end
      end

      def prepare_data(buckets, files)
        data = files.each_with_object({}) do |f, hash|
          hash[f.bucket.name] ||= []
          hash[f.bucket.name] << f.key
        end

        buckets.each do |b|
          data[b.name] ||= [] if b.public
        end

        tree = TTY::Tree.new(data)
        return tree, data
      end

      def render_results(output, tree, data)
        output.puts

        if data.keys.any?
          output.puts pastel.red('Found public objects!')
          output.puts
          output.puts(tree.render)
        else
          output.puts pastel.green('Success! You are safe')
        end
      end
    end
  end
end
