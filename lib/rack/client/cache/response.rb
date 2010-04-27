module Rack
  module Client
    module Cache
      class Response < Rack::Client::Response
        include Rack::Response::Helpers

        def not_modified?
          status == 304
        end

        alias_method :finish, :to_a

        # Status codes of responses that MAY be stored by a cache or used in reply
        # to a subsequent request.
        #
        # http://tools.ietf.org/html/rfc2616#section-13.4
        CACHEABLE_RESPONSE_CODES = [
          200, # OK
          203, # Non-Authoritative Information
          300, # Multiple Choices
          301, # Moved Permanently
          302, # Found
          404, # Not Found
          410  # Gone
        ].to_set

        # A Hash of name=value pairs that correspond to the Cache-Control header.
        # Valueless parameters (e.g., must-revalidate, no-store) have a Hash value
        # of true. This method always returns a Hash, empty if no Cache-Control
        # header is present.
        def cache_control
          @cache_control ||= CacheControl.new(headers['Cache-Control'])
        end

        def cacheable?
          return false unless CACHEABLE_RESPONSE_CODES.include?(status)
          return false if cache_control.no_store? || cache_control.private?
          validateable? || fresh?
        end

        # The literal value of ETag HTTP header or nil if no ETag is specified.
        def etag
          headers['ETag']
        end

        def validateable?
          headers.key?('Last-Modified') || headers.key?('ETag')
        end

        # The literal value of the Vary header, or nil when no header is present.
        def vary
          headers['Vary']
        end

        # Does the response include a Vary header?
        def vary?
          ! vary.nil?
        end
      end
    end
  end
end
