module Fog
  module Compute
    class Linode
      class Real
        def image_delete(image_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => {
              :api_action => 'image.delete',
              :imageId => image_id
            }
          )
        end
      end

      class Mock
        def image_delete(image_id, status='available')
          size = rand(1..999999)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "ERRORARRAY" => [],
            "ACTION"     => "image.delete",
            "DATA"       => { "LAST_USED_DT" => "2014-07-21 12:31:54.0",
                              "DESCRIPTION" => "Fog Mock Linode Image #{image_id}",
                              "LABEL" => "test_#{image_id}_image",
                              "STATUS" => status,
                              "SIZE" => size,
                              "ISPUBLIC" => rand(0..1),
                              "CREATE_DT" => "2014-06-23 13:45:12.0",
                              "USED" => rand(1..size),
                              "FS_TYPE" => "ext4",
                              "USERID" => Fog::Mock.random_numbers(4),
                              "IMAGEID" => image_id }
          }
          response
        end
      end
    end
  end
end
