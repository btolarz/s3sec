# frozen_string_literal: true

require_relative '../command'
require 'aws-sdk'

module S3sec
  module Commands
    class Config < S3sec::Command
      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        id, key = nil, nil

        id = config.fetch(:AWS_ACCESS_KEY_ID) if config.exist?
        key = config.fetch(:AWS_SECRET_ACCESS_KEY) if config.exist?

        result = prompt.collect do
          key(:AWS_ACCESS_KEY_ID).ask("AWS_ACCESS_KEY_ID #{id}:", default: ENV['AWS_ACCESS_KEY_ID'])
          key(:AWS_SECRET_ACCESS_KEY).ask("AWS_SECRET_ACCESS_KEY #{key}:", default: ENV['AWS_SECRET_ACCESS_KEY'])
        end

        config.set(:AWS_ACCESS_KEY_ID, value: result[:AWS_ACCESS_KEY_ID]) if !result[:AWS_ACCESS_KEY_ID].nil?
        config.set(:AWS_SECRET_ACCESS_KEY, value: result[:AWS_SECRET_ACCESS_KEY]) if !result[:AWS_SECRET_ACCESS_KEY].nil?

        client = Aws::S3::Client.new(
         credentials: Aws::Credentials.new(config.fetch(:AWS_ACCESS_KEY_ID), config.fetch(:AWS_SECRET_ACCESS_KEY)),
         region: 'eu-central-1'
        )

        begin
          output.puts 'Testing ...'
          client.list_buckets
          config.write(force: true)
          output.puts pastel.green('Done!')
        rescue => e
          output.puts pastel.red(e)
        end
      end
    end
  end
end
