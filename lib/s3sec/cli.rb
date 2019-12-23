# frozen_string_literal: true

require 'thor'

module S3sec
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    desc 'version', 's3sec version'
    def version
      require_relative 'version'
      puts "v#{S3sec::VERSION}"
    end
    map %w(--version -v) => :version

    desc 'check', 'Check open buckets and public files'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    def check(*)
      if options[:help]
        invoke :help, ['check']
      else
        require_relative 'commands/check'
        S3sec::Commands::Check.new(options).execute
      end
    end

    desc 'config', 'Configure aws credentials'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    def config(*)
      if options[:help]
        invoke :help, ['config']
      else
        require_relative 'commands/config'
        S3sec::Commands::Config.new(options).execute
      end
    end
  end
end
