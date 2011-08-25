module Fog
  module Compute
    class Ninefold
      class Real

        def list_virtual_machines(options = {})
          request('listVirtualMachines', options, :expects => [200],
                  :response_prefix => 'listvirtualmachinesresponse/virtualmachine', :response_type => Array)
        end

      end
    end
  end
end
