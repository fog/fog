module Fog
  module Storage
    class StormOnDemand
      class Real

        def create_volume(options={})
          request(
            :path => '/Storage/Block/Volume/create',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
