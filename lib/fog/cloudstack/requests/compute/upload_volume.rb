module Fog
  module Compute
    class Cloudstack

      class Real
        # Uploads a data disk.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/uploadVolume.html]
        def upload_volume(zoneid, name, url, format, options={})
          options.merge!(
            'command' => 'uploadVolume', 
            'zoneid' => zoneid, 
            'name' => name, 
            'url' => url, 
            'format' => format  
          )
          request(options)
        end
      end

    end
  end
end

