module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a Nicira NVP device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addNiciraNvpDevice.html]
        def add_nicira_nvp_device(username, physicalnetworkid, transportzoneuuid, password, hostname, options={})
          options.merge!(
            'command' => 'addNiciraNvpDevice', 
            'username' => username, 
            'physicalnetworkid' => physicalnetworkid, 
            'transportzoneuuid' => transportzoneuuid, 
            'password' => password, 
            'hostname' => hostname  
          )
          request(options)
        end
      end

    end
  end
end

