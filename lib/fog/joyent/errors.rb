module Fog
  module Compute
    class Joyent < Fog::Service

      class Errors
        module MessageParserMixin
          def message
            if response.body["code"] && response.body["message"]
              "[ERROR #{response.body['code']}] : #{response.body['message']}"
            else
              ''
            end
          end

          def to_s
            message
          end
        end

        # https://us-west-1.api.joyentcloud.com/docs#cloudapi-http-responses
        #
        # HTTP Status Codes
        # 
        # Your client should check for each of the following status codes from any API request:
        # 
        # Response  Code  Description

        # 400 Bad Request Invalid HTTP Request
        class BadRequest < Excon::Errors::BadRequest
          include MessageParserMixin
        end

        # 401 Unauthorized  Either no Authorization header was sent, or invalid credentials were used
        class Unauthorized < Excon::Errors::Unauthorized
          include MessageParserMixin
        end

        # 403 Forbidden No permissions to the specified resource
        class Forbidden < Excon::Errors::Forbidden
          include MessageParserMixin
        end

        # 404 Not Found Something you requested was not found
        class NotFound < Excon::Errors::NotFound
          include MessageParserMixin
        end

        # 405 Method Not Allowed  Method not supported for the given resource
        class MethodNotAllowed < Excon::Errors::MethodNotAllowed
          include MessageParserMixin
        end

        # 406 Not Acceptable  Try sending a different Accept header
        class NotAcceptable < Excon::Errors::NotAcceptable
          include MessageParserMixin
        end

        # 409 Conflict  Most likely invalid or missing parameters
        class Conflict < Excon::Errors::Conflict
          include MessageParserMixin
        end

        # 413 Request Entity Too Large  You sent too much data
        class RequestEntityTooLarge < Excon::Errors::RequestEntityTooLarge
          include MessageParserMixin
        end

        # 415 Unsupported Media Type  You encoded your request in a format we don't understand
        class UnsupportedMediaType < Excon::Errors::UnsupportedMediaType
          include MessageParserMixin
        end

        # 420 Slow Down You're sending too many requests
        class PolicyNotForfilled < Excon::Errors::HTTPStatusError
          include MessageParserMixin
        end

        # 449 Retry With  Invalid Version header; try with a different X-Api-Version string
        class RetryWith < Excon::Errors::HTTPStatusError
          include MessageParserMixin
        end

        # 503 Service Unavailable Either there's no capacity in this datacenter, or we're in a maintenance window
        class ServiceUnavailable < Excon::Errors::ServiceUnavailable
          include MessageParserMixin
        end
      end
    end
  end
end
