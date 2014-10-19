module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates an ip address
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateIpAddress.html]
        def update_ip_address(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateIpAddress') 
          else
            options.merge!('command' => 'updateIpAddress', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

