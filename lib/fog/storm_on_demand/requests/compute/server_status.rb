module Fog
  module Compute
    class StormOnDemand
      class Real
        def server_status(options={})
          request(
            :path => '/Storm/Server/status',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
