module Fog
  module Support
    class StormOnDemand
      class Real
        def authenticate(options={})
          request(
            :path => '/Support/Ticket/authenticate',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
