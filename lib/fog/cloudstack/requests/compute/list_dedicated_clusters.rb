module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists dedicated clusters.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listDedicatedClusters.html]
        def list_dedicated_clusters(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listDedicatedClusters') 
          else
            options.merge!('command' => 'listDedicatedClusters')
          end
          request(options)
        end
      end

    end
  end
end

