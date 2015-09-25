module Vapor
  module Logger
    def log message
      logger.info("[vapor] #{message}") if logging?
    end

    def logger
      @logger ||= options[:logger] || ::Logger.new(STDOUT)
    end

    def logger=(logger)
      @logger = logger
    end

    def logging?
      options[:log]
    end
  end
end
