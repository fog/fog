module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a Cisco Vnmc controller
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteCiscoVnmcResource.html]
        def delete_cisco_vnmc_resource(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteCiscoVnmcResource') 
          else
            options.merge!('command' => 'deleteCiscoVnmcResource', 
            'resourceid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

