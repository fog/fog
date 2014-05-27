module Fog
  module Compute
    class Cloudstack

      class Real
        # Delete a Ucs manager
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteUcsManager.html]
        def delete_ucs_manager(options={})
          options.merge!(
            'command' => 'deleteUcsManager', 
            'ucsmanagerid' => options['ucsmanagerid']  
          )
          request(options)
        end
      end

    end
  end
end

