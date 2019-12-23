# S3sec

Check your s3 buckets.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 's3_sec'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install s3_sec

## Usage

```bash
s3sec config # provide credentials
s3sec check # check open buckets and public files
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/s3sec. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the S3sec project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/s3sec/blob/master/CODE_OF_CONDUCT.md).

## Copyright

Copyright (c) 2019 btolarz. See [MIT License](LICENSE.txt) for further details.
