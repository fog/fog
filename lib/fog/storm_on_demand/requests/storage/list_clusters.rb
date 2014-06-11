module Fog
  module Storage
    class StormOnDemand
      class Real
        def list_clusters(options={})
          request(
            :path => '/Storage/Block/Cluster/list',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
