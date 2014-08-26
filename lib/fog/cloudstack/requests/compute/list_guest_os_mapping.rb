module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all available OS mappings for given hypervisor
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listGuestOsMapping.html]
        def list_guest_os_mapping(options={})
          request(options)
        end


        def list_guest_os_mapping(options={})
          options.merge!(
            'command' => 'listGuestOsMapping'  
          )
          request(options)
        end
      end

    end
  end
end

