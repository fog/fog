module Fog
  module Rackspace
    class BlockStorage
      class Real
        def get_volume_type(volume_type_id)
          request(
            :expects => [200],
            :method => 'GET',
            :path => "types/#{volume_type_id}"
          )
        end
      end

      class Mock
        def get_volume_type(volume_type_id)
          type = self.data[:volume_types][volume_type_id]
          if type.nil?
            raise Fog::Rackspace::BlockStorage::NotFound
          else
            type = type.dup
            type["id"] = type["id"].to_s
            response(:body => {"volume_type" => type})
          end
        end
      end
    end
  end
end
