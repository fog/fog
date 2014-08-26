module Fog
  module Compute
    class Cloudstack

      class Real
        # Copies an iso from one zone to another.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/copyIso.html]
        def copy_iso(options={})
          request(options)
        end


        def copy_iso(destzoneid, id, options={})
          options.merge!(
            'command' => 'copyIso', 
            'destzoneid' => destzoneid, 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

