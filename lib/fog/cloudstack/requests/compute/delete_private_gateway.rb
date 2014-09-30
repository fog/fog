module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a Private gateway
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deletePrivateGateway.html]
        def delete_private_gateway(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deletePrivateGateway') 
          else
            options.merge!('command' => 'deletePrivateGateway', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

