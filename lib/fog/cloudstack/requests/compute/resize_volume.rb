module Fog
  module Compute
    class Cloudstack

      class Real
        # Resizes a volume
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/resizeVolume.html]
        def resize_volume(options={})
          options.merge!(
            'command' => 'resizeVolume'  
          )
          request(options)
        end
      end

    end
  end
end

