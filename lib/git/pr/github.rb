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
        repositories = [@git.repository]

        if all
          Octokit.organizations.map(&:login).each do |org|
            # XXX pagination?
            repositories << Octokit.organization_repositories(org, per_page: 100).map(&:full_name)
          end
        end

        [].tap do |prs|
          repositories.flatten.uniq.each do |repo|
            prs << Octokit.pull_requests(repo, 'open')
          end
        end.flatten
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
