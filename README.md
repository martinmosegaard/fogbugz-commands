# Fogbugz::Commands

[![Gem Version](https://badge.fury.io/rb/fogbugz-commands.svg)](https://badge.fury.io/rb/fogbugz-commands)
[![Build Status](https://travis-ci.org/martinmosegaard/fogbugz-commands.svg?branch=master)](https://travis-ci.org/martinmosegaard/fogbugz-commands)
[![Code Climate](https://codeclimate.com/github/martinmosegaard/fogbugz-commands/badges/gpa.svg)](https://codeclimate.com/github/martinmosegaard/fogbugz-commands)
[![Test Coverage](https://codeclimate.com/github/martinmosegaard/fogbugz-commands/badges/coverage.svg)](https://codeclimate.com/github/martinmosegaard/fogbugz-commands/coverage)

Command line interaction with FogBugz.

## Installation

    gem install fogbugz-commands

## Setup

Create a file in your home directory called `.fogbugz.yml`. Provide the following content used for login:

    email: you@company.com
    server: company.fogbugz.com

## Usage

Use `report` to view the time registered in a time interval on a particular case or for a particular person:

    fogbugz report --from 2016-10-01 --to 2017-02-12 --id 67
    fogbugz report --from 2016-10-01 --to 2017-02-12 --case 12345

Use `last_week` to view the time registered for a particular case, all persons in the previous week:

    fogbugz last_week --case 12345

Use `this_week` to view the time registered for a particular person, all cases in the current week:

    fogbugz this_week --id 67

Use `person` to view details of a person based on the person's FogBugz ID:

    fogbugz person --id 67

View help on all commands or a specific command with:

    fogbugz help
    fogbugz help <command>

## External Links

- [The FogBugz API](http://help.fogcreek.com/the-fogbugz-api)
- [Using JSON with the FogBugz API](http://help.fogcreek.com/10853/using-json-with-the-fogbugz-api)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Comments, bug reports and pull requests are welcome on GitHub at https://github.com/martinmosegaard/fogbugz-commands.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
