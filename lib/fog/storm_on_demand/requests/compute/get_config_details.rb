module Fog
  module Compute
    class StormOnDemand
      class Real

        def get_config_details(options={})
          request(
            :path => '/Storm/Config/details',
            :body => Fog::JSON.encode({ :params => options })
          )
        end
        
      end
    end
  end
end
