module Fog
  module Compute
    class Cloudstack

      class Real
        # create secondary staging store.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createSecondaryStagingStore.html]
        def create_secondary_staging_store(options={})
          options.merge!(
            'command' => 'createSecondaryStagingStore', 
            'url' => options['url']  
          )
          request(options)
        end
      end

    end
  end
end

