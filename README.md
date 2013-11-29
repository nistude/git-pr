# Git::Pr

[![Build Status](https://secure.travis-ci.org/nistude/git-pr.png?branch=master)](http://travis-ci.org/nistude/git-pr)
[![Dependency Status](https://gemnasium.com/nistude/git-pr.png?travis)](https://gemnasium.com/nistude/git-pr)
[![Code Climate](https://codeclimate.com/github/nistude/git-pr.png)](https://codeclimate.com/github/nistude/git-pr)

`git-pr` facilitates GitHub pull requests.

## Installation

Add this line to your application's Gemfile:

    gem 'git-pr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git-pr

## Configuration

Setup a [personal access token](https://github.com/settings/applications)
and configure your git for github:

    $ git config --global github.user your_github_user_name
    $ git config --global github.token your_github_personal_access_token

## Usage

List pull requests:

    $ git pr list                # open pull requests for the active repository

You can also configure repository profiles and use those to query multiple
repositories at once:

    $ git config --global --add pr.repository_profile.work org/one
    $ git config --global --add pr.repository_profile.work org/two
    $ git pr list --profile work # open pull requests for 'org/one', 'org/two'

Submit a pull request for the current branch:

    $ git pr submit --title "my title" --message "longer description"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
