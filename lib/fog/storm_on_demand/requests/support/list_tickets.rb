module Fog
  module Support
    class StormOnDemand
      class Real

        def list_tickets(options={})
          request(
            :path => '/Support/Ticket/list',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
