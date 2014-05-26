module Fog
  module Support
    class StormOnDemand
      class Real
        def get_active_alert(options={})
          request(
            :path => '/Support/Alert/getActive',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
