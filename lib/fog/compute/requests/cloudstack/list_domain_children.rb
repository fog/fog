module Fog
  module Compute
    class Cloudstack
      class Real

        def list_domain_children(options={})
          options.merge!(
            'command' => 'listDomainChildren'
          )
          
          request(options)
        end

      end
    end
  end
end
