module Fog
  module Compute
    class StormOnDemand
      class Real

        def update_server(options={})
          request(
            :path => '/Storm/Server/update',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
