module Fog
  module Compute
    class Cloudstack

      class Real
        # Extracts volume
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/extractVolume.html]
        def extract_volume(options={})
          options.merge!(
            'command' => 'extractVolume', 
            'mode' => options['mode'], 
            'id' => options['id'], 
            'zoneid' => options['zoneid']  
          )
          request(options)
        end
      end

    end
  end
end

