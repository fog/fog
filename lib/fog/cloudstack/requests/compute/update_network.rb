module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a network
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateNetwork.html]
        def update_network(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateNetwork') 
          else
            options.merge!('command' => 'updateNetwork', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

