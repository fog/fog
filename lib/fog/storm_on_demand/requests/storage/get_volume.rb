module Fog
  module Storage
    class StormOnDemand
      class Real

        def get_volume(options={})
          request(
            :path => '/Storage/Block/Volume/details',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
