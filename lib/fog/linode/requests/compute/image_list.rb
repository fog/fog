module Fog
  module Compute
    class Linode
      class Real
        def image_list(pending=nil, image_id=nil)
          options = {}
          if pending
            options.merge!(:pending => pending)
          end
          if image_id
            options.merge!(:imageId => image_id)
          end
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'image.list' }.merge!(options)
          )
        end
      end

      class Mock
        def image_list(pending=nil, image_id=nil)
          response = Excon::Response.new
          response.status = 200
          body = {
            "ERRORARRAY" => [],
            "ACTION" => "image.list"
          }
          if image_id
            mock_image = create_mock_image(image_id)
            response.body = body.merge("DATA" => [mock_image])
          else
            mock_images = []
            rand(1..3).times do
              image_id = Fog::Mock.random_numbers(5)
              mock_images << create_mock_image(image_id)
            end
            response.body = body.merge("DATA" => mock_images)
          end
          response
        end

        private

        def create_mock_image(image_id, status='available')
          size = rand(1...999999)
          {
            "LAST_USED_DT" => "2014-07-29 12:55:29.0",
            "DESCRIPTION" => "Fog Mock Linode Image #{image_id}",
            "LABEL"      => "test_#{image_id}_image",
            "STATUS"     => status,
            "TYPE"       => "manual",
            "ISPUBLIC"   => rand(0...1),
            "CREATE_DT"  => "2014-06-29 5:39:19.0",
            "MINSIZE"    => Fog::Mock.random_numbers(5),
            "FS_TYPE"    => "ext4",
            "CREATOR"    => "test_username",
            "IMAGEID"    => image_id
          }
        end
      end
    end
  end
end
