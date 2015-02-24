module Fog
  module Compute
    class Ovirt
      class Real
        def get_affinity_group(id)
          ovirt_attrs client.affinity_group(id)
        end
      end

      class Mock
        def get_affinity_group(id)
          nil
        end
      end
    end
  end
end
