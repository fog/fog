module Fog
  module Compute
    class Cloudstack

      class Real
        # Uploads a data disk.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/uploadVolume.html]
        def upload_volume(options={})
          request(options)
        end


        def upload_volume(url, format, zoneid, name, options={})
          options.merge!(
            'command' => 'uploadVolume', 
            'url' => url, 
            'format' => format, 
            'zoneid' => zoneid, 
            'name' => name  
          )
          request(options)
        end
      end

    end
  end
end

