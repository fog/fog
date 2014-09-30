module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates the volume.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateVolume.html]
        def update_volume(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateVolume') 
          else
            options.merge!('command' => 'updateVolume')
          end
          request(options)
        end
      end

    end
  end
end

