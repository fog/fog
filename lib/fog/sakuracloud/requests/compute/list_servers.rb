# coding: utf-8

module Fog
  module Compute
    class SakuraCloud
      class Real
        def list_servers(options = {})
          request(
            :headers => {
              'Authorization' => "Basic #{@auth_encord}"
            },
            :method => 'GET',
            :path => "#{Fog::SakuraCloud::SAKURACLOUD_API_ENDPOINT}/server"
          )
        end
      end

      class Mock
        def list_servers(options = {})
          response = Excon::Response.new
          response.status = 200
          response.body = {
          "Servers" =>
            [
            {"Index" => 0,
              "ID"=>112600055376,
              "Name"=>"foober1",
              "ServerPlan"=> {},
              "Instance"=> {},
              "Disks"=> []},
            {"Index" => 1,
              "ID"=>112600055377,
              "Name"=>"foober2",
              "ServerPlan"=> {},
              "Instance"=> {},
              "Disks"=> []}
            ]
          }
          response
        end
      end
    end
  end
end
