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
            'zoneid' => options['zoneid'], 
            'id' => options['id'], 
            'mode' => options['mode'], 
             
          )
          request(options)
        end
      end

    end
  end
end

