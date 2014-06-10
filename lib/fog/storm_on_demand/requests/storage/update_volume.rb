module Fog
  module Storage
    class StormOnDemand
      class Real
        def update_volume(options={})
          request(
            :path => '/Storage/Block/Volume/update',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
