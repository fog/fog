module Fog
  module Network
    class StormOnDemand
      class Real
        def get_assignments(options={})
          request(
            :path => '/Network/Pool/list',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
