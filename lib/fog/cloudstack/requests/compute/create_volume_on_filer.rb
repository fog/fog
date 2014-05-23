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
            'poolname' => options['poolname'], 
            'username' => options['username'], 
            'ipaddress' => options['ipaddress'], 
            'volumename' => options['volumename'], 
            'password' => options['password'], 
            'size' => options['size'], 
            'aggregatename' => options['aggregatename'], 
             
          )
          request(options)
        end
      end

    end
  end
end

