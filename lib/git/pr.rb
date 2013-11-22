require 'octokit'

require 'git/pr/version'

module Git
  class Pr
    def self.run(args)
      new(args).run
    end

    def initialize(args)
      @command = args.shift
      @args = args
    end

    def run
      if @command && self.respond_to?(@command, true)
        self.send(@command)
      else
        raise "Bad command #@command"
      end
    end

    private
    def submit
      title = @args[0]
      body = @args[1]
      Octokit.configure do |c|
        c.login = 'nistude'
        c.password = 'ooCooneb0bee8ja1'
      end
      Octokit.create_pull_request('nistude/git-pr', 'master', 'create_pr_for_current_branch', title, body)
    end
  end
end
