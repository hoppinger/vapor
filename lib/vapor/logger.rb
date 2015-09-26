module Vapor
  module Logger
    class << self
      attr_writer :logger
    end

    def log(message)
      logger.info("[vapor] #{message}") if logging?
    end

    def logger
      @logger ||= options[:logger] || ::Logger.new(STDOUT)
    end

    def logging?
      options[:log]
    end
  end
end
