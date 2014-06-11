module Fog
  module Compute
    class Ninefold
      class Real
        def list_capabilities(options = {})
          request('listCapabilities', options, :expects => [200],
                  :response_prefix => 'listcapabilitiesresponse/capability', :response_type => Array)
        end
      end
    end
  end
end
