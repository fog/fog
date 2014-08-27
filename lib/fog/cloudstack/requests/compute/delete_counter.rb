module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a counter
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteCounter.html]
        def delete_counter(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteCounter') 
          else
            options.merge!('command' => 'deleteCounter', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

