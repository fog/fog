module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a BigSwitch VNS device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addBigSwitchVnsDevice.html]
        def add_big_switch_vns_device(options={})
          request(options)
        end


        def add_big_switch_vns_device(hostname, physicalnetworkid, options={})
          options.merge!(
            'command' => 'addBigSwitchVnsDevice', 
            'hostname' => hostname, 
            'physicalnetworkid' => physicalnetworkid  
          )
          request(options)
        end
      end

    end
  end
end

