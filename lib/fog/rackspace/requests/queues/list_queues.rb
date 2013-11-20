module Fog
  module Rackspace
    class Queues
      class Real

        # This operation lists queues for the project. The queues are sorted alphabetically by name.
        # @note A request to list queues when you have no queues in your account returns 204, instead of 200, because there was no information to send back.
        #
        # @param [Hash] options
        # @option options [String] :marker - Specifies the name of the last queue received in a previous request, or none to get the first page of results.
        # @option options [Integer] :limit - Specifies the name of the last queue received in a previous request, or none to get the first page of results.
        # @option options [Boolean] :detailed - Determines whether queue metadata is included in the response. The default value for this parameter is false, which excludes t
        # @return [Excon::Response] response
        # @raise [Fog::Rackspace::Queues::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Queues::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Queues::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Queues::ServiceError]
        # @see http://docs.rackspace.com/queues/api/v1.0/cq-devguide/content/GET_listQueues__version__queues_.html
        def list_queues(options={})
          request(
            :expects => [200, 204],
            :method => 'GET',
            :path => 'queues',
            :query => options
          )
        end
      end
    end
  end
end
