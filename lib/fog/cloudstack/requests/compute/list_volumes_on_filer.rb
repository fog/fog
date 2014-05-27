module Fog
  module Compute
    class Cloudstack

      class Real
        # List Volumes
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listVolumesOnFiler.html]
        def list_volumes_on_filer(options={})
          options.merge!(
            'command' => 'listVolumesOnFiler', 
            'poolname' => options['poolname']  
          )
          request(options)
        end
      end

    end
  end
end

