module Fog
  module Compute
    class OpenStack
      class Real

        def list_volumes(detailed=true)
          path = detailed ? 'os-volumes/detail' : 'os-volumes'
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => path
          )
        end

      end

      class Mock

        def list_volumes(detailed=true)
          response = Excon::Response.new
          response.status = 200
          self.data[:volumes] ||= [
            { "status" => "available",
              "display_description" => "",
              "availability_zone" => "nova",
              "display_name" => "test 1",
              "attachments" => [{}],
              "volume_type" => nil,
              "snapshot_id" => nil,
              "size" => 1,
              "id" => Fog::Mock.random_hex(32),
              "created_at" => Time.now },
            { "status" => "available",
              "display_description" => "",
              "availability_zone" => "nova",
              "display_name" => "test 2",
              "attachments" => [{}],
              "volume_type" => nil,
              "snapshot_id" => nil,
              "size" => 1,
              "id" => Fog::Mock.random_hex(32),
              "created_at" => Time.now }
            ]
          response.body = { 'volumes' => self.data[:volumes] }
          response
        end
      end

    end
  end
end
