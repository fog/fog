module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_operating_system
      end

      class Mock
        def get_operating_system(uri)
          os_name, compute_pool_id = uri.match(/operatingsystems\/(.*)\/computepools\/(\d+)$/).captures
          compute_pool_id          = compute_pool_id.to_i

          operating_systems = self.data[:operating_systems].values.select{|os| os[:compute_pool_id] == compute_pool_id}
          operating_system = operating_systems.find{|os| os[:short_name] == os_name}

          if operating_system
            response(:body => Fog::Ecloud.slice(operating_system, :id, :compute_pool_id, :short_name))
          else response(:status => 404) # ?
          end
        end
      end
    end
  end
end
