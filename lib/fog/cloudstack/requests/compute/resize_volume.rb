module Fog
  module Compute
    class Cloudstack

      class Real
        # Resizes a volume
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/resizeVolume.html]
        def resize_volume(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'resizeVolume') 
          else
            options.merge!('command' => 'resizeVolume', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

