module Fog
  module Compute
    class StormOnDemand
      class Real

        def get_image_details(options={})
          request(
            :path => '/Storm/Image/details',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
