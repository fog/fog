module Fog
  module Storage
    class StormOnDemand
      class Real
        def list_volumes(options={})
          request(
            :path => '/Storage/Block/Volume/list',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
