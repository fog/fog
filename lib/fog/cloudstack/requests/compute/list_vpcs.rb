module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists VPCs
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listVPCs.html]
        def list_vpcs(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listVPCs') 
          else
            options.merge!('command' => 'listVPCs')
          end
          request(options)
        end
      end

    end
  end
end

