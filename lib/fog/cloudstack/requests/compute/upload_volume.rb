module Fog
  module Compute
    class Cloudstack

      class Real
        # Uploads a data disk.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/uploadVolume.html]
        def upload_volume(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'uploadVolume') 
          else
            options.merge!('command' => 'uploadVolume', 
            'url' => args[0], 
            'format' => args[1], 
            'zoneid' => args[2], 
            'name' => args[3])
          end
          request(options)
        end
      end

    end
  end
end

