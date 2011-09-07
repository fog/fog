module Fog
  module Compute
    class Ninefold
      class Real

        def list_templates(options = {})
          request('listTemplates', options, :expects => [200],
                  :response_prefix => 'listtemplatesresponse/template', :response_type => Array)
        end

      end
    end
  end
end
