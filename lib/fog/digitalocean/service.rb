module Fog
  module DigitalOcean
    class Service

      def request(params, parse_json = true)
        first_attempt = true
        begin
          response = @connection.request(request_params(params))
        rescue Excon::Errors::Unauthorized => error
          raise error unless first_attempt
          first_attempt = false
          authenticate
          retry
        end

        process_response(response) if parse_json
        response
      end

      private

      def process_response(response)
        if response &&
          response.body &&
          response.body.is_a?(String) &&
          !response.body.strip.empty?
          begin
            response.body = Fog::JSON.decode(response.body)
          rescue Fog::JSON::DecodeError => e
            Fog::Logger.warning("Error Parsing response json - #{e}")
            response.body = {}
          end
        end
      end

      def headers(options={})
        {'Content-Type' => 'application/json',
         'Accept'       => 'application/json',
        }.merge(options[:headers] || {})
      end

      def request_params(params)
        params.merge({
                       :headers => headers(params),
                       :path    => "#{params[:path]}"
                     })
      end

    end
  end
end