require "net/dav"
require "vapor/version"
require "vapor/configuration"
require "vapor/logger"
require "vapor/owncloud"

module Vapor
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
