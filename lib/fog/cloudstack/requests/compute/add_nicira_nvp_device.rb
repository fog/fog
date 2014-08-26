module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a Nicira NVP device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addNiciraNvpDevice.html]
        def add_nicira_nvp_device(options={})
          request(options)
        end


        def add_nicira_nvp_device(physicalnetworkid, transportzoneuuid, username, password, hostname, options={})
          options.merge!(
            'command' => 'addNiciraNvpDevice', 
            'physicalnetworkid' => physicalnetworkid, 
            'transportzoneuuid' => transportzoneuuid, 
            'username' => username, 
            'password' => password, 
            'hostname' => hostname  
          )
          request(options)
        end
      end

    end
  end
end

