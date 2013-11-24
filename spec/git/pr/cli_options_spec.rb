require 'spec_helper'
require 'git/pr/cli_options'

describe Git::Pr::CliOptions do
  context 'when the subcommand is missing' do
    it 'raises an error' do
      expect { Git::Pr::CliOptions.parse([]) }.to \
        raise_error Git::Pr::CliOptions::Invalid, 'missing subcommand'
    end
  end

  context 'when the subcommand is unknown' do
    it 'raises an error' do
      expect { Git::Pr::CliOptions.parse(['foo']) }.to \
        raise_error Git::Pr::CliOptions::Invalid, 'unknown subcommand'
    end
  end

  describe 'subcommands' do
    describe 'submit' do
      let(:options) { Git::Pr::CliOptions.parse(['submit',
                                                 '--title', 'my title',
                                                 '--message', 'my message']) }

      it 'extracts the subcommand from the command line arguments' do
        expect(options.subcommand).to eq 'submit'
      end

      it 'parses pull request title' do
        expect(options.title).to eq 'my title'
      end

      it 'parses pull request message' do
        expect(options.message).to eq 'my message'
      end

      it 'raises an error on unknown arguments' do
        expect { Git::Pr::CliOptions.parse(['submit', '--foo']) }.to \
          raise_error Git::Pr::CliOptions::Invalid, /^invalid option/
      end

      it 'raises an error for missing arguments' do
        expect { Git::Pr::CliOptions.parse(['submit', '--title', 'foo']) }.to \
          raise_error Git::Pr::CliOptions::Invalid, 'missing arguments'
      end
    end
  end
end
