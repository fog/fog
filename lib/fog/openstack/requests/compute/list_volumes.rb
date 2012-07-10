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
              "displayDescription" => "",
              "availabilityZone" => "nova",
              "displayName" => "test 1",
              "attachments" => [{}],
              "volumeType" => nil,
              "snapshotId" => Fog::Mock.random_numbers(2),
              "size" => 1,
              "id" => "6",
              "createdAt" => Time.now },
            { "status" => "available",
              "displayDescription" => "",
              "availabilityZone" => "nova",
              "displayName" => "test 2",
              "attachments" => [{}],
              "volumeType" => nil,
              "snapshotId" => Fog::Mock.random_numbers(2),
              "size" => 1,
              "id" => "8",
              "createdAt" => Time.now}
            ]
          response.body = { 'volumes' => self.data[:volumes] }
          response
        end
      end

    end
  end
end
