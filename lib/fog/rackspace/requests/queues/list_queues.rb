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

      class Mock
        def list_queues(options={})
          limit = options[:limit] || 10
          marker = options[:marker]
          detailed = options[:detailed] || false

          queue_names = data.keys.sort
          start_index = marker.nil? ? 0 : queue_names.count { |name| name <= marker }
          stop_index = start_index + limit

          queue_names = queue_names[start_index..stop_index]
          queue_data = queue_names.map do |qname|
            { "href" => "#{PATH_BASE}/#{qname}", "name" => qname }
          end

          if detailed
            queue_data.each { |d| d["metadata"] = data[d["name"]].metadata }
          end

          response = Excon::Response.new
          if data.empty?
            response.status = 204
          else
            response.status = 200
            response.body = {
              "queues" => queue_data,
              "links" => [{ "href" => "#{PATH_BASE}?marker=#{queue_names.last}", "rel" => "next" }]
            }
          end
          response
        end
      end
    end
  end
end
