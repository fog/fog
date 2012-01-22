module Fog
  module Compute
    class Ovirt
      class Real

        def storage_domains filter={}
          client.storage_domains(filter)
        end

      end

      class Mock
        def storage_domains filter={}
          [ "Storage", "Storage2", "Storage3" ]
        end
      end
    end
  end
end
