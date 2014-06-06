module Fog
  module Compute
    class Cloudstack

      class Real
        # Extracts volume
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/extractVolume.html]
        def extract_volume(zoneid, mode, id, options={})
          options.merge!(
            'command' => 'extractVolume', 
            'zoneid' => zoneid, 
            'mode' => mode, 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

