module Fog
  module Compute
    class Cloudstack

      class Real
        # Extracts volume
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/extractVolume.html]
        def extract_volume(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'extractVolume') 
          else
            options.merge!('command' => 'extractVolume', 
            'mode' => args[0], 
            'id' => args[1], 
            'zoneid' => args[2])
          end
          request(options)
        end
      end

    end
  end
end

