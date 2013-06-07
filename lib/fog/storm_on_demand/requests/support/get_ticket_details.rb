module Fog
  module Support
    class StormOnDemand
      class Real

        def get_ticket_details(options={})
          request(
            :path => '/Support/Ticket/details',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
