module Fog
  module Compute
    class Cloudstack

      class Real
        # refresh ucs blades to sync with UCS manager
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/refreshUcsBlades.html]
        def refresh_ucs_blades(ucsmanagerid, options={})
          options.merge!(
            'command' => 'refreshUcsBlades', 
            'ucsmanagerid' => ucsmanagerid  
          )
          request(options)
        end
      end

    end
  end
end

