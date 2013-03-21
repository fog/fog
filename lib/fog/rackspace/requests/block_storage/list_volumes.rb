module Fog
  module Rackspace
    class BlockStorage
      class Real

        # Retrieves list of volumes
        # @return [Excon::Response] response
        # @see http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/GET_getVolumesSimple__v1__tenant_id__volumes.html
        def list_volumes
          request(
            :expects => [200],
            :method => 'GET',
            :path => 'volumes'
          )
        end
      end

      class Mock
        def list_volumes
          volumes = self.data[:volumes].values
          response(:body => {"volumes" => volumes})
        end
      end
    end
  end
end
