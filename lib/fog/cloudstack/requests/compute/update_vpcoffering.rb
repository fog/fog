module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates VPC offering
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateVPCOffering.html]
        def update_vpcoffering(options={})
          options.merge!(
            'command' => 'updateVPCOffering',
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

