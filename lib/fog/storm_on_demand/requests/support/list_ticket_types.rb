module Fog
  module Support
    class StormOnDemand
      class Real
        def list_ticket_types(options={})
          request(
            :path => '/Support/Ticket/types',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
