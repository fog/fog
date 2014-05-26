module Fog
  module Compute
    class RackspaceV2
      class Real
        # Retrieves a list of flavors
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * flavors [Array]:
        #       * [Hash]:
        #         * id [String] - flavor id
        #         * links [Array] - flavor links
        #         * name [String] - flavor name
        #         * ram [Fixnum] - flavor ram
        #         * disk [Fixnum] - flavor disk
        #         * vcpus [Fixnum] - flavor vcpus
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/List_Flavors-d1e4188.html
        def list_flavors_detail
          request(
            :expects => [200, 203],
            :method => 'GET',
            :path => 'flavors/detail'
          )
        end
      end

      class Mock
        def list_flavors_detail
          flavors = self.data[:flavors].values.map { |f| Fog::Rackspace::MockData.keep(f, 'id', 'name', 'links') }
          response(:body => {"flavors" => flavors})
        end
      end
    end
  end
end
