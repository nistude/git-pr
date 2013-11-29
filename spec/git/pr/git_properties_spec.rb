require 'spec_helper'
require 'git/pr/git_properties'

describe Git::Pr::GitProperties do
  let(:git) { Git::Pr::GitProperties.new }

  describe '#api_token' do
    it 'returns the user`s GitHub API token' do
      git.stub(:`).with(/github.token/).and_return('foo')

      expect(git.api_token).to eq 'foo'
    end
  end

  describe '#current_branch' do
    it 'returns the name of the current branch' do
      git.stub(:`).with(/symbolic-ref/).and_return('refs/heads/foo')

      expect(git.current_branch).to eq 'foo'
    end
  end

  describe '#repository' do
    it 'returns the name of the GitHub repository' do
      git.stub(:`).with(/remote.origin.url/).and_return('git@github.com:foo/bar.git')

      expect(git.repository).to eq 'foo/bar'
    end
  end

  describe '#login' do
    it 'returns the user`s GitHub login name' do
      git.stub(:`).with(/github.user/).and_return('foo')

      expect(git.login).to eq 'foo'
    end
  end

  describe '#repository_profile' do
    it 'returns an array of repositories in the given profile' do
      git.stub(:`).with(/pr.repository_profile.foo/).and_return("repo/one\nrepo/two\n")

      expect(git.repository_profile('foo')).to eq ['repo/one', 'repo/two']
    end
  end
end
