module Fog
  module Compute
    class Cloudstack

      class Real
        # Registers an existing ISO into the CloudStack Cloud.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/registerIso.html]
        def register_iso(options={})
          request(options)
        end


        def register_iso(name, displaytext, url, zoneid, options={})
          options.merge!(
            'command' => 'registerIso', 
            'name' => name, 
            'displaytext' => displaytext, 
            'url' => url, 
            'zoneid' => zoneid  
          )
          request(options)
        end
      end

    end
  end
end

