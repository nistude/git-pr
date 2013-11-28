require 'octokit'

module Git
  class Pr
    class GitHub
      class Failed < StandardError; end

      def initialize(git_properties)
        @git = git_properties

        Octokit.configure do |c|
          c.login = @git.login
          c.password = @git.api_token
        end
      end

      def list_pull_requests(all, mine)
        Octokit.pull_requests(@git.repository, 'open')
      end

      def submit_pull_request(title, message)
        response = Octokit.create_pull_request(@git.repository,
                                               @git.base_branch,
                                               @git.current_branch,
                                               title,
                                               message)
        response.state == 'open' ? response : raise(Failed, response.state)
      rescue Octokit::UnprocessableEntity => e
        message = e.message.match(/message: (.*)/)[1].sub(/ \/\/.*/, '')
        raise Failed, message
      end
    end
  end
end
