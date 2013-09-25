module Fog
  module Compute
    class StormOnDemand
      class Real

        def restore_image(options={})
          request(
            :path => '/Storm/Image/restore',
            :body => Fog::JSON.encode(params => options)
          )
        end

      end
    end
  end
end
