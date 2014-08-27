module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes an ISO file.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteIso.html]
        def delete_iso(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteIso') 
          else
            options.merge!('command' => 'deleteIso', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

