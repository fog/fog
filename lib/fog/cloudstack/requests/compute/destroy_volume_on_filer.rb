module Fog
  module Compute
    class Cloudstack

      class Real
        # Destroy a Volume
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/destroyVolumeOnFiler.html]
        def destroy_volume_on_filer(ipaddress, aggregatename, volumename, options={})
          options.merge!(
            'command' => 'destroyVolumeOnFiler', 
            'ipaddress' => ipaddress, 
            'aggregatename' => aggregatename, 
            'volumename' => volumename  
          )
          request(options)
        end
      end

    end
  end
end

