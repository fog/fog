module Fog
  module Compute
    class Cloudstack

      class Real
        # Extracts an ISO
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/extractIso.html]
        def extract_iso(mode, id, options={})
          options.merge!(
            'command' => 'extractIso', 
            'mode' => mode, 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

