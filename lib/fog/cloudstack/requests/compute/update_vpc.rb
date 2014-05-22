module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a VPC
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateVPC.html]
        def update_vpc(options={})
          options.merge!(
            'command' => 'updateVPC',
            'id' => options['id'], 
            'name' => options['name'], 
             
          )
          request(options)
        end
      end

    end
  end
end

