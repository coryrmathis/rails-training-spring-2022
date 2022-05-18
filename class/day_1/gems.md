## Gems 

- [Commonly Used Gems at GitHub](#commonly-used-gems-at-github)

As we have seen throughout this exercise, gems are commonly used to bring in additional code that can be used in our application. This allows us to utilize tools that other developers have already created rather than redefining them ourselves. If we look in our `Gemfile.lock` we see all the gems that were install locally to make this application function. At Github, there is a protocol for adding and updating gems that can be found [here](https://githubber.com/article/technology/dotcom/howto-manage-gems) and should be referenced. Gems that are sourced from rubygems.org will use the `bin/bundle` script to install, update and add while internal gems will use the script `script/vendor-gem`. Github also vendors their gems which means that a copy exists within the project directory instead of just locally. The reasoning behind this is because they have added some customization to certain gems and keeping them with the project ensures that the gem changes go with it.

### Commonly Used Gems at GitHub

- [Actionview-Component](https://github.com/github/actionview-component) - a framework for building view components in Rails.
- [Failbot](https://github.com/github/failbot) - Exception reporting library
- [Faker](https://github.com/faker-ruby/faker) - Generates random fake data. Mostly used in tests. This includes several “clever” categories of data (e.g. Star Wars characters. Using clever data categories has proven problematic in the past.
- [Faraday](https://lostisland.github.io/faraday/) - HTTP client library
- [Flipper](https://github.com/jnunemaker/flipper) - Feature flipping
- [Graphql](https://graphql-ruby.org) - Server side of GraphQL
- [Graphql-client](https://github.com/github/graphql-client) - Client side of GraphQL
- [Nokogiri](https://nokogiri.org/) - HTML, XML, SAX, and Reader parser. Able to search documents via XPath or CSS3 selectors.
- [Rack](https://github.com/rack/rack) - Ruby web server interface. Wraps HTTP requests / responses and provides a standard API for web frameworks, web servers and middleware.
- [Scientist](https://github.com/github/scientist) - A Ruby library for carefully refactoring critical paths. Compares new/old implementations and compares behaviors in production.
- [Sinatra](http://sinatrarb.com/) - DSL / Framework for Ruby web apps. (A lightweight alternative to Rails.) Sinatra is used for the API portion of the monolith.
- [Factory Bot / Factory Bot Rails](https://github.com/thoughtbot/factory_bot) - Fixtures replacement (create and roll back test model data)
- [Pry](https://github.com/pry/pry) - Debugger
- [Rubocop](https://docs.rubocop.org/en/stable/) - Ruby Linter / Formatter
- [Minitest](https://github.com/seattlerb/minitest) - Testing Framework
- [Mocha](https://github.com/freerange/mocha) - Mocking and Stubbing for tests
- [Timecop](https://github.com/travisjeffery/timecop) - A gem providing "time travel" and "time freezing" capabilities, making it dead simple to test time-dependent code.
- [VCR](https://github.com/vcr/vcr) - Records the test suite's HTTP requests and replay them during future test runs.
- [Github-DS](https://github.com/github/github-ds) - This exists and is used in production but do not use it for new code
A collection of Ruby libraries for working with SQL on top of ActiveRecord's connection. This was previously used a lot but use of this gem is discouraged. Use ActiveRecord instead.
