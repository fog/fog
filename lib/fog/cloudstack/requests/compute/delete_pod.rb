module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a Pod.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deletePod.html]
        def delete_pod(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deletePod') 
          else
            options.merge!('command' => 'deletePod', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

