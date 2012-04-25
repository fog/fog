module Fog
  module Compute
    class Libvirt
      class Real
        def volume_action(key, action, options={})
          get_volume({:key => key}, true).send(action)
          true
        end
      end

      class Mock
        def volume_action(action, options={})
          true
        end
      end
    end
  end
end
