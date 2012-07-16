module Fog
  module Image
    class OpenStack
      class Real

        def create_image(attributes)


          data = {
              "Content-Type"=>"application/octet-stream",
              "x-image-meta-name" => attributes[:name],
              "x-image-meta-disk-format" => attributes[:disk_format],
              "x-image-meta-container-format" => attributes[:container_format],
              "x-image-meta-size" => attributes[:size],
              "x-image-meta-is-public" => attributes[:is_public],
              "x-image-meta-owner" => attributes[:owner],
              "x-glance-api-copy-from" => attributes[:copy_from]
          }

          body = String.new
          if attributes[:location]
            file = File.open(attributes[:location], "rb")
            body = file
          end

          unless attributes[:properties].nil?
            attributes[:properties].each do |key,value|
              data["x-image-meta-property-#{key}"] = value
            end
          end



          request(
            :headers     => data,
            :body     => body,
            :expects  => 201,
            :method   => 'POST',
            :path     => "images"
          )
        ensure
          body.close if body.respond_to?(:close)
        end

      end

      class Mock

        def create_image(attributes)
          response = Excon::Response.new
          response.status = 201
          response.body = {"image"=>
                               {"name"=>"new image",
                                "size"=>0,
                                "min_disk"=>0,
                                "disk_format"=>nil,
                                "created_at"=>"2012-02-24T06:45:00",
                                "container_format"=>nil,
                                "deleted_at"=>nil,
                                "updated_at"=>"2012-02-24T06:45:00",
                                "checksum"=>nil,
                                "id"=>"e41304f3-2453-42b4-9829-2e220a737395",
                                "deleted"=>false,
                                "protected"=>false,
                                "is_public"=>false,
                                "status"=>"queued",
                                "min_ram"=>0,
                                "owner"=>"728ecc7c10614a1faa6fbabd1a68a4a0",
                                "properties"=>{}
                               }
                           }
          response

        end

      end
    end
  end
end
