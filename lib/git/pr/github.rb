require 'octokit'

module Git
  class Pr
    class GitHub
      def initialize(git_properties)
        @git = git_properties

        Octokit.configure do |c|
          c.login = @git.login
          c.password = @git.api_token
        end
      end

      def submit_pull_request(title, message)
        puts "#{@git.repository} #{@git.base_branch} #{@git.current_branch} #{title} #{message}"
        return
        Octokit.create_pull_request(@git.repository,
                                    @git.base_branch,
                                    @git.current_branch,
                                    title,
                                    message)
      end
    end
  end
end
