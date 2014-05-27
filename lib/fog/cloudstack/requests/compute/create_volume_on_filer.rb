module Fog
  module Compute
    class Cloudstack

      class Real
        # Create a volume
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createVolumeOnFiler.html]
        def create_volume_on_filer(options={})
          options.merge!(
            'command' => 'createVolumeOnFiler', 
            'volumename' => options['volumename'], 
            'aggregatename' => options['aggregatename'], 
            'password' => options['password'], 
            'poolname' => options['poolname'], 
            'ipaddress' => options['ipaddress'], 
            'size' => options['size'], 
            'username' => options['username']  
          )
          request(options)
        end
      end

    end
  end
end

