module Fog
  module Compute
    class Cloudstack

      class Real
        # Restarts a VPC
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/restartVPC.html]
        def restart_vpc(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'restartVPC') 
          else
            options.merge!('command' => 'restartVPC', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

