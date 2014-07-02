module Fog
  module Compute
    class Cloudstack

      class Real
        # list the vm nics  IP to NIC
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listNics.html]
        def list_nics(virtualmachineid, options={})
          options.merge!(
            'command' => 'listNics', 
            'virtualmachineid' => virtualmachineid  
          )
          request(options)
        end
      end

    end
  end
end

