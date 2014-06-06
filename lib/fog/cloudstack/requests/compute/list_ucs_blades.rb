module Fog
  module Compute
    class Cloudstack

      class Real
        # List ucs blades
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listUcsBlades.html]
        def list_ucs_blades(ucsmanagerid, options={})
          options.merge!(
            'command' => 'listUcsBlades', 
            'ucsmanagerid' => ucsmanagerid  
          )
          request(options)
        end
      end

    end
  end
end

