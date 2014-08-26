module Fog
  module Compute
    class Cloudstack

      class Real
        # Extracts an ISO
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/extractIso.html]
        def extract_iso(options={})
          request(options)
        end


        def extract_iso(id, mode, options={})
          options.merge!(
            'command' => 'extractIso', 
            'id' => id, 
            'mode' => mode  
          )
          request(options)
        end
      end

    end
  end
end

