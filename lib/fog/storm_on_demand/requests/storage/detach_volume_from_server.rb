module Fog
  module Storage
    class StormOnDemand
      class Real

        def detach_volume_from_server(options={})
          request(
            :path => '/Storage/Block/Volume/detach',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
