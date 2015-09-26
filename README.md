# Vapor

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/vapor`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vapor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vapor

## Usage

Configure Vapor by adding your own_cloud credentials via an initializer `config/initializers/vapor.rb`

    Vapor.configure do |config|
      config.base_url = ENV["OWN_CLOUD_BASE_URL"]
      config.base_path = ENV["OWN_CLOUD_BASE_PATH"]
      config.username = ENV["OWN_CLOUD_USER"]
      config.password = ENV["OWN_CLOUD_BASE_PASSWORD"]
    end

To check if a path exists

    Vapor.exists?('destination')
    Vapor.exists?('des tina tion')  # Spaces are allowed
    Vapor.exists?('des&tination')   # Special chars are allowed
    Vapor.exists?('destination/dest.file')

In order to delete a path

    Vapor.delete('destination')            # Directories
    Vapor.delete('destination/dest.file')  # As well as Files

In order to put a file

    Vapor.put_file('destination.file')

In order to get a file

    Vapor.get_file('destination.file')

In order to list files in path

    Vapor.list_files('remote-folder')

In order to create a directory

    Vapor.mkdir('orphan')
    Vapor.mkdir('parent/child')
    Vapor.mkdir('parent/child/grand_child')

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/vapor.

## Hoppinger

This gem was created by [Hoppinger](http://www.hoppinger.com)

[![forthebadge](http://forthebadge.com/images/badges/built-with-ruby.svg)](http://www.hoppinger.com)
