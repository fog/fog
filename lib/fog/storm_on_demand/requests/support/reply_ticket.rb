module Fog
  module Support
    class StormOnDemand
      class Real

        def reply_ticket(options={})
          request(
            :path => '/Support/Ticket/reply',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
