module Fog
  module Compute
    class Cloudstack

      class Real
        #  delete a bigswitch vns device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteBigSwitchVnsDevice.html]
        def delete_big_switch_vns_device(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteBigSwitchVnsDevice') 
          else
            options.merge!('command' => 'deleteBigSwitchVnsDevice', 
            'vnsdeviceid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

