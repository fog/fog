module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds secondary storage.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addSecondaryStorage.html]
        def add_secondary_storage(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addSecondaryStorage') 
          else
            options.merge!('command' => 'addSecondaryStorage', 
            'url' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

