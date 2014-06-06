module Fog
  module Compute
    class Cloudstack

      class Real
        # Destroy a LUN
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/destroyLunOnFiler.html]
        def destroy_lun_on_filer(path, options={})
          options.merge!(
            'command' => 'destroyLunOnFiler', 
            'path' => path  
          )
          request(options)
        end
      end

    end
  end
end

