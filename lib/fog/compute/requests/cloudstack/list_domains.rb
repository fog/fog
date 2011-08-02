module Fog
  module Compute
    class Cloudstack
      class Real

        def list_domains(options={})
          options.merge!(
            'command' => 'listDomains'
          )
          
          request(options)
        end

      end
    end
  end
end
