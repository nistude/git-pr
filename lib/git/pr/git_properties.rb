module Git
  class Pr
    class GitProperties
      def api_endpoint
        `git config --get github.apiEndpoint`.chomp
      end

      def api_token
        `git config --get github.token`.chomp
      end

      def base_branch
        'master'
      end

      def current_branch
        `git symbolic-ref HEAD`.split('/').last.chomp
      end

      def repository
        `git config --get remote.origin.url`.split(':').last.sub(/\.git/, '').chomp
      end

      def login
        `git config --get github.user`.chomp
      end

      def repository_profile(profile)
        `git config --get-all pr.repository_profile.#{profile}`.split(/\n/)
      end
    end
  end
end
