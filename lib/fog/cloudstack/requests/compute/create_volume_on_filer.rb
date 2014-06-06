module Fog
  module Compute
    class Cloudstack

      class Real
        # Create a volume
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createVolumeOnFiler.html]
        def create_volume_on_filer(password, ipaddress, size, volumename, username, poolname, aggregatename, options={})
          options.merge!(
            'command' => 'createVolumeOnFiler', 
            'password' => password, 
            'ipaddress' => ipaddress, 
            'size' => size, 
            'volumename' => volumename, 
            'username' => username, 
            'poolname' => poolname, 
            'aggregatename' => aggregatename  
          )
          request(options)
        end
      end

    end
  end
end

