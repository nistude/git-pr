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
          c.api_endpoint = @git.api_endpoint unless @git.api_endpoint.empty?
          c.auto_paginate = true
        end
      end

      def list_pull_requests(profile, mine)
        if profile
          repositories = profile == :all ? all_repositories
                                         : @git.repository_profile(profile)
        else
          repositories = [@git.repository]
        end

        [].tap do |prs|
          repositories.flatten.uniq.each do |repo|
            pull_requests = Octokit.pull_requests(repo, 'open')
            if mine
              prs << pull_requests.select { |pr| pr.user.login == @git.login }
            else
              prs << pull_requests
            end
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

      private
      def all_repositories
        repositories = []

        Octokit.organizations.map(&:login).each do |org|
          repositories << Octokit.organization_repositories(org).map(&:full_name)
        end
        repositories << Octokit.repositories.map(&:full_name)

        repositories
      end
    end
  end
end
