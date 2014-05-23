module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates the volume.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateVolume.html]
        def update_volume(options={})
          options.merge!(
            'command' => 'updateVolume',
            'id' => options['id'], 
            'path' => options['path'], 
             
          )
          request(options)
        end
      end

    end
  end
end

