module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_compute_pools
      end

      class Mock
        def get_compute_pools(uri) # /cloudapi/ecloud/computepools/environments/534
          environment_id = id_from_uri(uri)
          environment    = self.data[:environments][environment_id]

          compute_pools  = self.data[:compute_pools].values.select{|cp| cp[:environment_id] == environment_id}

          compute_pools = compute_pools.map{|cp| Fog::Ecloud.slice(cp, :id, :environment_id)}

          compute_pool_response = {:ComputePool => (compute_pools.size > 1 ? compute_pools : compute_pools.first)} # GAH
          body = {
            :href  => uri,
            :type  => "application/vnd.tmrk.cloud.computePool; type=collection",
            :Links => {
              :Link => environment,
            }
          }.merge(compute_pool_response)

          response(:body => body)
        end
      end
    end
  end
end
