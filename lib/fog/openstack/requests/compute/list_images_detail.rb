module Fog
  module Compute
    class OpenStack
      class Real
        def list_images_detail(filters = {})
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'images/detail.json',
            :query    => filters
          )
        end
      end

      class Mock
        def list_images_detail(filters = {})
          response = Excon::Response.new

          images = self.data[:images].values
          for image in images
            case image['status']
            when 'SAVING'
              if Time.now - self.data[:last_modified][:images][image['id']] >= Fog::Mock.delay
                image['status'] = 'ACTIVE'
              end
            end
          end

          response.status = [200, 203][rand(1)]
          response.body = { 'images' => images.map {|image| image.reject {|key, value| !['id', 'name', 'links', 'minRam', 'minDisk', 'metadata', 'status', 'updated'].include?(key)}} }
          response
        end
      end
    end
  end
end
