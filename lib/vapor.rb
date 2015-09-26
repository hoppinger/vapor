require "net/dav"
require "logger"
require "vapor/version"
require "vapor/configuration"
require "vapor/logger"
require "vapor/owncloud"

module Vapor
  extend Logger

  class << self
    attr_writer :configuration, :logger
  end

  def self.options
    @options ||= {
      log: true,
      logger: nil
    }
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  # def self.logger
  #   @logger ||= Logger.new
  # end
end
