module Fog
  module Compute
    class Cloudstack

      class Real
        # Copies an iso from one zone to another.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/copyIso.html]
        def copy_iso(id, sourcezoneid, destzoneid, options={})
          options.merge!(
            'command' => 'copyIso', 
            'id' => id, 
            'sourcezoneid' => sourcezoneid, 
            'destzoneid' => destzoneid  
          )
          request(options)
        end
      end

    end
  end
end

