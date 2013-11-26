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
      @args = args
      @github = GitHub.new(GitProperties.new)
    end

    def run
      @options = CliOptions.parse(@args)
      if self.respond_to?(@options.subcommand)
        self.send(@options.subcommand)
      else
        be_helpful
      end
    rescue CliOptions::Invalid => e
      be_helpful(e.message)
    end

    def submit
      pr = @github.submit_pull_request(@options.title, @options.message)
      puts "Opened new pull request to merge #{pr.head.ref} into #{pr.base.repo.full_name}/#{pr.base.ref}"
    rescue GitHub::Failed => e
      $stderr.puts "Failed to open new pull request: #{e.message}"
      exit 1
    end

    private
    def be_helpful(message = nil)
      puts message if message
      puts <<-USAGE
Usage: git pr help|-h
   or: git pr list
   or: git pr submit --title TITLE [--message MESSAGE]
      USAGE
    end
  end
end
