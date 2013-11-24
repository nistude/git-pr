require 'octokit'

require 'git/pr/cli_options'
require 'git/pr/git_properties'
require 'git/pr/version'

module Git
  class Pr
    def self.run(args)
      new(args).run
    end

    def initialize(args)
      @args = args
      @git = GitProperties.new
    end

    def run
      @options = CliOptions.parse(@args)
      setup_credentials
      if self.respond_to?(@options.subcommand)
        self.send(@options.subcommand)
      else
        be_helpful
      end
    rescue CliOptions::Invalid => e
      be_helpful(e.message)
    end

    def submit
      Octokit.create_pull_request(@git.repository,
                                  @git.base_branch,
                                  @git.current_branch,
                                  @options.title,
                                  @options.message)
    end

    private
    def setup_credentials
      Octokit.configure do |c|
        c.login = @git.login
        c.password = @git.api_token
      end
    end

    def be_helpful(message = nil)
      puts message
      puts <<-USAGE
Usage: git pr list [state] [--reverse]
   or: git pr submit --title TITLE --message MESSAGE
      USAGE
    end
  end
end
