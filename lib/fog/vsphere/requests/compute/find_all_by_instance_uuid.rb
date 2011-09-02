module Fog
  module Compute
    class Vsphere
      class Real

        def find_all_by_instance_uuid(uuid)
          @connection.searchIndex.FindAllByUuid(:uuid => uuid, 'vmSearch' => true, 'instanceUuid' => true)
        end

      end

      class Mock

        def find_all_by_instance_uuid(uuid)
          Fog::Mock.not_implmented
        end

      end
    end
  end
end
