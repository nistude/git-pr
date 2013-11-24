require 'optparse'
require 'virtus'

module Git
  class Pr
    class CliOptions
      include Virtus.value_object(:constructor => false)

      values do
        attribute :subcommand
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
          case subcommand
          when 'submit'
            mandatory = [:title, :message]
            opts.on('--title TITLE') { |title| self.title = title }
            opts.on('--message MESSAGE') { |message| self.message = message }
          else
            raise(Invalid, 'unknown subcommand')
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
