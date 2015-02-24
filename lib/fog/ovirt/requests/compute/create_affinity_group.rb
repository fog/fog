module Fog
  module Compute
    class Ovirt
      class Real
        def create_affinity_group(attrs)
          client.create_affinity_group(attrs)
        end
      end

      class Mock
        def create_affinity_group(attrs)
          nil
        end
      end
    end
  end
end
