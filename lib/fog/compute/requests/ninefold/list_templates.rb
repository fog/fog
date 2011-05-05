module Fog
  module Ninefold
    class Compute
      class Real

        def list_templates(options = {})
          request('listTemplates', options, :expects => [200],
                  :response_prefix => 'listtemplatesresponse/template', :response_type => Array)
        end

      end

      class Mock

        def list_templates(*args)
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
