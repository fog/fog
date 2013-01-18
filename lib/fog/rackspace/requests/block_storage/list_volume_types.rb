module Fog
  module Rackspace
    class BlockStorage
      class Real
        def list_volume_types
          request(
            :expects => [200],
            :method => 'GET',
            :path => 'types'
          )
        end
      end

      class Mock
        def list_volume_types
          types = self.data[:volume_types].values
          response(:body => {"volume_types" => types})
        end
      end
    end
  end
end
