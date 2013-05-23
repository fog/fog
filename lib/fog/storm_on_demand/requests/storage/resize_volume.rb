module Fog
  module Storage
    class StormOnDemand
      class Real

        def resize_volume(options={})
          request(
            :path => '/Storage/Block/Volume/resize',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
