module Fog
  module Compute
    class Cloudstack
      class Real

        def list_virtual_machines(options={})
          options.merge!(
            'command' => 'listVirtualMachines'
          )
          
          request(options)
        end

      end
    end
  end
end
