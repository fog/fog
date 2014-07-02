module Fog
  module Compute
    class Cloudstack

      class Real
        #  delete a nicira nvp device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteNiciraNvpDevice.html]
        def delete_nicira_nvp_device(nvpdeviceid, options={})
          options.merge!(
            'command' => 'deleteNiciraNvpDevice', 
            'nvpdeviceid' => nvpdeviceid  
          )
          request(options)
        end
      end

    end
  end
end

