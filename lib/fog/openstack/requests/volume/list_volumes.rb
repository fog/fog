module Fog
  module Volume
    class OpenStack
      class Real

        def list_volumes(detailed=true)

          path = detailed ? 'volumes/detail' : 'volumes'
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
              "displayDescription" => "",
              "availabilityZone" => "nova",
              "displayName" => "test 1",
              "attachments" => [{}],
              "volumeType" => nil,
              "snapshotId" => nil,
              "size" => 1,
              "id" => 6,
              "createdAt" => "2012-03-30 05:31:00.655058",
              "metadata" => {} },
            { "status" => "available",
              "displayDescription" => "",
              "availabilityZone" => "nova",
              "displayName" => "test 2",
              "attachments" => [{}],
              "volumeType" => nil,
              "snapshotId" => nil,
              "size" => 1,
              "id" => 8,
              "createdAt" => "2012-03-30 16:14:55.582717",
              "metadata" => {} }
            ]
          response.body = { 'volumes' => self.data[:volumes] }
          response
        end
      end

    end
  end
end

