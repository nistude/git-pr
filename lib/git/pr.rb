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

    def list
      prs = @github.list_pull_requests(@options.list_all, @options.mine)
      prs.each do |pr|
        puts pr
      end
    end

    def submit
      pr = @github.submit_pull_request(@options.title, @options.message)
      puts "Opened new pull request to merge #{pr.head.ref} into #{pr.base.repo.full_name}/#{pr.base.ref}"
    rescue GitHub::Failed => e
      $stderr.puts "Failed to open new pull request: #{e.message}"
      exit 1
    end

    def version
      puts Git::Pr::VERSION
    end

    private
    def be_helpful(message = nil)
      puts message if message
      puts <<-USAGE
Usage: git pr list [options]
   or: git pr submit [options]
   or: git pr version
      USAGE
    end
  end
end
