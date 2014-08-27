module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a VPC
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateVPC.html]
        def update_vpc(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateVPC') 
          else
            options.merge!('command' => 'updateVPC', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

