module Fog
  module Storage
    class StormOnDemand
      class Real

        def attach_volume_to_server(options={})
          request(
            :path => '/Storage/Block/Volume/attach',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
