module Fog
  module CloudSigma
    module Errors
      class Error < Fog::Errors::Error
        attr_accessor :type, :error_point

        def initialize(message, type='n/a', error_point=nil)
          @type = type
          @error_point = error_point
          super(message)
        end
      end

      class NotFound < Error; end
      class RequestError < Error; end
      class ServerError < Error; end

      def self.slurp_http_status_error(error)
        error_class =  case error.response[:status]
                         when 404
                           NotFound
                         when 500..599
                           ServerError
                         when 400..499
                           RequestError
                         else
                           Error
                       end

        new_error = error_class.new(error.response[:body].first['error_message'],
                                    error.response[:body].first['error_type'],
                                    error.response[:body].first['error_point'])
        new_error.set_backtrace(error.backtrace)
        new_error.verbose = error.message
        new_error
      end
    end
  end
end
