module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists VPCs
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listVPCs.html]
        def list_vpcs(options={})
          options.merge!(
            'command' => 'listVPCs'  
          )
          request(options)
        end
      end

    end
  end
end

