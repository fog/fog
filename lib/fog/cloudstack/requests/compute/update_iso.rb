module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates an ISO file.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateIso.html]
        def update_iso(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateIso') 
          else
            options.merge!('command' => 'updateIso', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

