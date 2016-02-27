# Vapor

[![Build Status](http://drone.hoppinger.com/api/badges/hoppinger/vapor/status.svg)](http://drone.hoppinger.com/hoppinger/vapor)


Welcome to vapor! With vapor you can interact with the web-dav interface of [OwnCloud](https://owncloud.org/).

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

Configure Vapor by adding your own_cloud credentials via an initializer;
eg: `config/initializers/vapor.rb`

    Vapor.configure do |config|
      config.base_url = ENV["OWN_CLOUD_BASE_URL"]
      config.base_path = ENV["OWN_CLOUD_BASE_PATH"]
      config.username = ENV["OWN_CLOUD_USER"]
      config.password = ENV["OWN_CLOUD_BASE_PASSWORD"]
    end

To check if a path exists

    Vapor.exists?('destination')           # Directories
    Vapor.exists?('des tina tion')         # Spaces are allowed
    Vapor.exists?('des&tination')          # Special chars are allowed
    Vapor.exists?('destination/dest.file') # Files

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
    Vapor.mkdir('parent/child')             # Nested
    Vapor.mkdir('parent/child/grand_child') # Deeply nested

## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hoppinger/vapor.

## Hoppinger

This gem was created by [Hoppinger](http://www.hoppinger.com)

[![forthebadge](http://forthebadge.com/images/badges/built-with-ruby.svg)](http://www.hoppinger.com)
