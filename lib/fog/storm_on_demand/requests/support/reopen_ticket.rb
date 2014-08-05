module Fog
  module Support
    class StormOnDemand
      class Real
        def reopen_ticket(options={})
          request(
            :path => '/Support/Ticket/reopen',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
