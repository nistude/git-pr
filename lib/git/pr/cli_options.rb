require 'optparse'
require 'virtus'

module Git
  class Pr
    class CliOptions
      include Virtus.value_object(constructor: false)

      values do
        attribute :subcommand
        # list
        attribute :mine, Boolean, default: false
        attribute :profile
        # submit
        attribute :title
        attribute :message
      end

      class Invalid < StandardError; end

      def self.parse(args)
        new(args).parse
      end

      def initialize(args)
        @args = args
      end

      def parse
        self.subcommand = @args.shift or raise(Invalid, 'missing subcommand')
        mandatory = []

        OptionParser.new do |opts|
          opts.banner = "Usage: git pr #{subcommand} [options]"
          case subcommand
          when 'help', '-h', 'version'
            # no specific options
          when 'list'
            opts.on('-a', '--all',
                    'Show pull requests for all repositories') do
              self.profile = :all
            end
            opts.on('-m', '--mine',
                    'Show only my pull requests') do
              self.mine = true
            end
            opts.on('-p', '--profile PROFILE',
                    'Show pull requests for all repositories in profile') do |profile|
              self.profile = profile
            end
          when 'submit'
            mandatory = [:title]
            opts.on('-t', '--title TITLE',
                    'Short description of pull request') do |title|
              self.title = title
            end
            opts.on('-m', '--message MESSAGE',
                    'Longer description of pull request') do |message|
              self.message = message
            end
          else
            raise(Invalid, "unknown subcommand: #{subcommand}")
          end
          opts.on_tail('-h', '--help', 'Show this message') do
            puts opts
            exit
          end
        end.parse!(@args)
        validate_options(mandatory)

        self
      rescue OptionParser::InvalidOption => e
        raise(Invalid, e.message)
      end

      private
      def validate_options(mandatory)
        mandatory.each do |arg|
          raise(Invalid, 'missing arguments') if self.send(arg).nil?
        end
      end
    end
  end
end
