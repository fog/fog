module Fog
  module Compute
    class Cloudstack

      class Real
        #  delete a bigswitch vns device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteBigSwitchVnsDevice.html]
        def delete_big_switch_vns_device(options={})
          request(options)
        end


        def delete_big_switch_vns_device(vnsdeviceid, options={})
          options.merge!(
            'command' => 'deleteBigSwitchVnsDevice', 
            'vnsdeviceid' => vnsdeviceid  
          )
          request(options)
        end
      end

    end
  end
end

