require "net/dav"
require "logger"
require "vapor/version"
require "vapor/configuration"
require "vapor/logger"
require "vapor/own_cloud"

module Vapor
  extend Logger
  extend OwnCloud

  class << self
    attr_writer :configuration, :logger
  end

  def self.options
    @options ||= {
      log: true,
      logger: nil,
      overwrite: false
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
