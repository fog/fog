module Fog
  module Compute
    class Cloudstack

      class Real
        # create secondary staging store.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createSecondaryStagingStore.html]
        def create_secondary_staging_store(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createSecondaryStagingStore') 
          else
            options.merge!('command' => 'createSecondaryStagingStore', 
            'url' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

