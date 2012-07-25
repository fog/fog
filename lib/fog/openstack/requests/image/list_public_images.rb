module Fog
  module Image
    class OpenStack
      class Real
        def list_public_images
          request(
            :expects => [200, 204],
            :method  => 'GET',
            :path    => 'images'
          )
        end
      end # class Real

      class Mock
        def list_public_images
          response = Excon::Response.new
          response.status = [200, 204][rand(1)]
          response.body = {
              "images"=>[{
                "name"=>"mock-image-name",
                "size"=>25165824,
                "disk_format"=>"ami",
                "container_format"=>"ami",
                "id"=>"0e09fbd6-43c5-448a-83e9-0d3d05f9747e",
                "checksum"=>"2f81976cae15c16ef0010c51e3a6c163"},
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
                }]
          }
          response
        end # def list_tenants
      end # class Mock
    end # class OpenStack
  end # module Identity
end # module Fog
