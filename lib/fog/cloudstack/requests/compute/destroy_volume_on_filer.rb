module Fog
  module Compute
    class Cloudstack

      class Real
        # Destroy a Volume
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/destroyVolumeOnFiler.html]
        def destroy_volume_on_filer(options={})
          options.merge!(
            'command' => 'destroyVolumeOnFiler',
            'aggregatename' => options['aggregatename'], 
            'volumename' => options['volumename'], 
            'ipaddress' => options['ipaddress'], 
             
          )
          request(options)
        end
      end

    end
  end
end

