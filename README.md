<h1 align="center">rspec-api-docs</h1>

<p align="center">Generate API documentation using RSpec</a>

<p align="center">
  <a href="https://travis-ci.org/twe4ked/rspec-api-docs"><img src="https://img.shields.io/travis/twe4ked/rspec-api-docs.svg?style=flat-square" /></a>
  <a href="https://rubygems.org/gems/rspec-api-docs"><img src="https://img.shields.io/gem/v/rspec-api-docs.svg?style=flat-square" /></a>
  <a href="http://www.rubydoc.info/github/twe4ked/rspec-api-docs/master"><img src="https://img.shields.io/badge/docs-master-lightgrey.svg?style=flat-square" /></a>
</p>

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-api-docs'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-api-docs

## Usage

See [the documentation](http://www.rubydoc.info/github/twe4ked/rspec-api-docs/master).

See the integration specs for some examples.

```
rm -rf spec/integration/output
rake generate_integration_docs
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to [rubygems.org].

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/twe4ked/rspec-api-docs. This project is intended to be a
safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant] code of
conduct.

## License

The gem is available as open source under the terms of the [MIT License].

[MIT License]: http://opensource.org/licenses/MIT
[Contributor Covenant]: http://contributor-covenant.org
[rubygems.org]: https://rubygems.org
