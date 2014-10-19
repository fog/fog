module Fog
  module Compute
    class Cloudstack

      class Real
        # Extracts an ISO
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/extractIso.html]
        def extract_iso(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'extractIso') 
          else
            options.merge!('command' => 'extractIso', 
            'id' => args[0], 
            'mode' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

