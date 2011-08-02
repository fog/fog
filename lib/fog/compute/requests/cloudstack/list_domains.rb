module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists domains and provides detailed information for listed domains.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listDomains.html]
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
