module Fog
  module Compute
    class Cloudstack

      class Real
        # Extracts an ISO
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/extractIso.html]
        def extract_iso(options={})
          options.merge!(
            'command' => 'extractIso',
            'mode' => options['mode'], 
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

