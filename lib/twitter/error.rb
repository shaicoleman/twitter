require 'twitter/rate_limit'

module Twitter
  # Custom error class for rescuing from all Twitter errors
  class Error < StandardError
    attr_reader :rate_limit, :wrapped_exception

    # @return [Hash]
    def self.errors
      @errors ||= {
        400 => Twitter::Error::BadRequest,
        401 => Twitter::Error::Unauthorized,
        403 => Twitter::Error::Forbidden,
        404 => Twitter::Error::NotFound,
        406 => Twitter::Error::NotAcceptable,
        422 => Twitter::Error::UnprocessableEntity,
        429 => Twitter::Error::TooManyRequests,
        500 => Twitter::Error::InternalServerError,
        502 => Twitter::Error::BadGateway,
        503 => Twitter::Error::ServiceUnavailable,
        504 => Twitter::Error::GatewayTimeout,
      }
    end

    # Initializes a new Error object
    #
    # @param exception [Exception, String]
    # @param response_headers [Hash]
    # @return [Twitter::Error]
    def initialize(exception=$!, response_headers={})
      @rate_limit = Twitter::RateLimit.new(response_headers)
      @wrapped_exception = exception
      exception.respond_to?(:backtrace) ? super(exception.message) : super(exception.to_s)
    end

    def backtrace
      @wrapped_exception.respond_to?(:backtrace) ? @wrapped_exception.backtrace : super
    end

  end
end
