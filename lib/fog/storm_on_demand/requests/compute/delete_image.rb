module Fog
  module Compute
    class StormOnDemand
      class Real
        def delete_image(options={})
          request(
            :path => '/Storm/Image/delete',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
