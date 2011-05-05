module Fog
  module Ninefold
    class Compute
      class Real

        def list_capabilities(options = {})
          request('listCapabilities', options, :expects => [200],
                  :response_prefix => 'listcapabilitiesresponse/capability', :response_type => Array)
        end

      end

      class Mock

        def list_capabilities(*args)
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
