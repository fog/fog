module Fog
  module Compute
    class Cloudstack

      class Real
        # Uploads a data disk.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/uploadVolume.html]
        def upload_volume(options={})
          options.merge!(
            'command' => 'uploadVolume', 
            'name' => options['name'], 
            'zoneid' => options['zoneid'], 
            'url' => options['url'], 
            'format' => options['format']  
          )
          request(options)
        end
      end

    end
  end
end

