module Fog
  module Support
    class StormOnDemand
      class Real
        def add_feedback(options={})
          request(
            :path => '/Support/Ticket/addFeedback',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
