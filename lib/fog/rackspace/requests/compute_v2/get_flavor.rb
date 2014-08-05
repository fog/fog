module Fog
  module Compute
    class RackspaceV2
      class Real
        # Retrieves flavor detail
        # @param [Sring] flavor_id
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * flavor [Hash]:
        #       * disk [Fixnum] - disk size in GB
        #       * id [String] - id of flavor
        #       * name [String] - name of flavor
        #       * ram [Fixnum] - amount of ram in MB
        #       * swap [Fixnum] - amount of swap in GB
        #       * vcpus [Fixnum] - number of virtual CPUs
        #       * links [Array] - links to flavor
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Get_Flavor_Details-d1e4317.html
        def get_flavor(flavor_id)
          request(
            :expects => [200, 203],
            :method => 'GET',
            :path => "flavors/#{Fog::Rackspace.escape(flavor_id)}"
          )
        end
      end

      class Mock
        def get_flavor(flavor_id)
          flavor = self.data[:flavors][flavor_id]
          if flavor.nil?
            raise Fog::Compute::RackspaceV2::NotFound
          else
            response(:body => {"flavor" => flavor})
          end
        end
      end
    end
  end
end
