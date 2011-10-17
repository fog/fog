module Fog
  module Compute
    class Ninefold
      class Real

        def list_hypervisors(options = {})
          request('listHypervisors', options, :expects => [200],
                  :response_prefix => 'listhypervisorsresponse/hypervisor', :response_type => Array)
        end

      end
    end
  end
end
