module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a host.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteHost.html]
        def delete_host(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteHost') 
          else
            options.merge!('command' => 'deleteHost', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

