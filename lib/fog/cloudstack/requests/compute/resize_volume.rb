module Fog
  module Compute
    class Cloudstack

      class Real
        # Resizes a volume
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/resizeVolume.html]
        def resize_volume(options={})
          request(options)
        end


        def resize_volume(id, options={})
          options.merge!(
            'command' => 'resizeVolume', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

