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
      prs = @github.list_pull_requests(@options.profile, @options.mine)
      puts formatted(prs)
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

    def terminal_size
      command_exists?('tput') ? `tput cols`.to_i : 80
    end

    def command_exists?(command)
      ENV['PATH'].split(File::PATH_SEPARATOR).any? do |dir|
        File.exists?(File.join(dir, command))
      end
    end

    def formatted(prs)
      if prs.empty?
        'No open pull requests'
      else
        prs.map do |pr|
          message = "#{pr.base.repo.full_name}: #{pr.title} -- (#{pr.user.login})"
          link = " #{pr._links.html.href} ".rjust(terminal_size - message.size)
          message + link
        end.join("\n")
      end
    end
  end
end
