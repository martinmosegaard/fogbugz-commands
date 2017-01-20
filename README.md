# Fogbugz::Commands

[![Gem Version](https://badge.fury.io/rb/fogbugz-commands.svg)](https://badge.fury.io/rb/fogbugz-commands)
[![Build Status](https://travis-ci.org/martinmosegaard/fogbugz-commands.svg?branch=master)](https://travis-ci.org/martinmosegaard/fogbugz-commands)
[![Code Climate](https://codeclimate.com/github/martinmosegaard/fogbugz-commands/badges/gpa.svg)](https://codeclimate.com/github/martinmosegaard/fogbugz-commands)

Command line interaction with FogBugz.

## Installation

    $ gem install fogbugz-commands

## Usage

    $ fogbugz help
    $ fogbugz last_week --server company.fogbugz.com --user ini@company.com --case 12345
    $ fogbugz person --server company.fogbugz.com --user ini@company.com --id 67

## External Links

- [The FogBugz API](http://help.fogcreek.com/the-fogbugz-api)
- [Using JSON with the FogBugz API](http://help.fogcreek.com/10853/using-json-with-the-fogbugz-api)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/martinmosegaard/fogbugz-commands.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
