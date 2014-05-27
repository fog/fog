module Fog
  module Compute
    class Cloudstack

      class Real
        # Registers an existing ISO into the CloudStack Cloud.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/registerIso.html]
        def register_iso(options={})
          options.merge!(
            'command' => 'registerIso', 
            'zoneid' => options['zoneid'], 
            'displaytext' => options['displaytext'], 
            'name' => options['name'], 
            'url' => options['url']  
          )
          request(options)
        end
      end

    end
  end
end

