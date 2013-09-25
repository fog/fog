module Fog
  module Support
    class StormOnDemand
      class Real

        def close_ticket(options={})
          request(
            :path => '/Support/Ticket/close',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
