module Fog
  module Compute
    class Cloudstack
      class Real

        def list_security_groups(options={})
          options.merge!(
            'command' => 'listSecurityGroups'
          )
          
          request(options)
        end

      end
    end
  end
end
