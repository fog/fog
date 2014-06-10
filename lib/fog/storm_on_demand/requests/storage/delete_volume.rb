module Fog
  module Storage
    class StormOnDemand
      class Real
        def delete_volume(options={})
          request(
            :path => '/Storage/Block/Volume/delete',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
