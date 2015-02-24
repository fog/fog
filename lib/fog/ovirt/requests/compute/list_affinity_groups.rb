module Fog
  module Compute
    class Ovirt
      class Real
        def list_affinity_groups(filters = {})
          client.affinity_groups(filters).map {|ovirt_obj| ovirt_attrs ovirt_obj}
        end
      end
      class Mock
        def list_affinity_groups(filters = {})
          []
        end
      end
    end
  end
end
