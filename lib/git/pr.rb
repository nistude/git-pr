require 'git/pr/cli_options'
require 'git/pr/git_properties'
require 'git/pr/github'
require 'git/pr/version'

module Git
  class Pr
    def self.run(args)
      new(args).run
    end

    def initialize(args)
      @options = CliOptions.parse(args)
      @github = GitHub.new(GitProperties.new)
    end

    def run
      if self.respond_to?(@options.subcommand)
        self.send(@options.subcommand)
      else
        be_helpful
      end
    rescue CliOptions::Invalid => e
      be_helpful(e.message)
    end

    def submit
      @github.submit_pull_request(@options.title, @options.message)
    end

    private
    def be_helpful(message = nil)
      puts message
      puts <<-USAGE
Usage: git pr list [state] [--reverse]
   or: git pr submit --title TITLE --message MESSAGE
      USAGE
    end
  end
end
