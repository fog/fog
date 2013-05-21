module Fog
  module Compute
    class StormOnDemand
      class Real

        def server_history(options={})
          request(
            :path => '/Storm/Server/history',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
