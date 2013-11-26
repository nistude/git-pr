module Git
  class Pr
    class GitProperties
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
    end
  end
end
