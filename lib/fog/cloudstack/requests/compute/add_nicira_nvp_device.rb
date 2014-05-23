module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a Nicira NVP device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addNiciraNvpDevice.html]
        def add_nicira_nvp_device(options={})
          options.merge!(
            'command' => 'addNiciraNvpDevice',
            'username' => options['username'], 
            'transportzoneuuid' => options['transportzoneuuid'], 
            'physicalnetworkid' => options['physicalnetworkid'], 
            'hostname' => options['hostname'], 
            'password' => options['password'], 
             
          )
          request(options)
        end
      end

    end
  end
end

