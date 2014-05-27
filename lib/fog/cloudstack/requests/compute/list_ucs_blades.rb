module Fog
  module Compute
    class Cloudstack

      class Real
        # List ucs blades
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listUcsBlades.html]
        def list_ucs_blades(options={})
          options.merge!(
            'command' => 'listUcsBlades', 
            'ucsmanagerid' => options['ucsmanagerid']  
          )
          request(options)
        end
      end

    end
  end
end

