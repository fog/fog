module Fog
  module Support
    class StormOnDemand
      class Real

        def create_ticket(options={})
          request(
            :path => '/Support/Ticket/create',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
