module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a network
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteNetwork.html]
        def delete_network(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteNetwork') 
          else
            options.merge!('command' => 'deleteNetwork', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

