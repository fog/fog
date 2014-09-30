module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a VPC
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteVPC.html]
        def delete_vpc(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteVPC') 
          else
            options.merge!('command' => 'deleteVPC', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

