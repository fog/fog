module Fog
  module Support
    class StormOnDemand
      class Real
        def add_transaction_feedback(options={})
          request(
            :path => '/Support/Ticket/addTransactionFeedback',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
