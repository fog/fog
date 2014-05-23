module Fog
  module Compute
    class Cloudstack

      class Real
        # Copies an iso from one zone to another.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/copyIso.html]
        def copy_iso(options={})
          options.merge!(
            'command' => 'copyIso',
            'destzoneid' => options['destzoneid'], 
            'sourcezoneid' => options['sourcezoneid'], 
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

