module Fog
  module Compute
    class IBM
      class Real

        # Get list of instances for a request
        #
        # ==== Parameters
        # * request_id<~String> - Id of request
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        # TODO: doc
        def get_request(request_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "computecloud/enterprise/api/rest/20100331/requests/#{request_id}"
          )
        end

      end

    end
  end
end
