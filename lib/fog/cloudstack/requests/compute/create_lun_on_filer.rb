module Fog
  module Compute
    class Cloudstack

      class Real
        # Create a LUN from a pool
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createLunOnFiler.html]
        def create_lun_on_filer(options={})
          options.merge!(
            'command' => 'createLunOnFiler', 
            'name' => options['name'], 
            'size' => options['size']  
          )
          request(options)
        end
      end

    end
  end
end

