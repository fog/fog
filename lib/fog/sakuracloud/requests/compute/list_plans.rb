# coding: utf-8

module Fog
  module Compute
    class SakuraCloud
      class Real
        def list_plans(options = {})
          request(
            :headers => {
              'Authorization' => "Basic #{@auth_encord}"
            },
            :method => 'GET',
            :path => "#{Fog::SakuraCloud::SAKURACLOUD_API_ENDPOINT}/product/server"
          )
        end
      end

      class Mock
        def list_plans(options = {})
          response = Excon::Response.new
          response.status = 200
          response.body = {
          "ServerPlans" =>
            [
            {"Index"=>0,
              "ID"=>1001,
              "Name"=>"プラン/1Core-1GB",
              "CPU"=>1,
              "MemoryMB"=>1024,
              "ServiceClass"=>"cloud/plan/1core-1gb",
              "Availability"=>"available"},
            {"Index"=>1,
              "ID"=>2001,
              "Name"=>"プラン/1Core-2GB",
              "CPU"=>1,
              "MemoryMB"=>2048,
              "ServiceClass"=>"cloud/plan/1core-2gb",
              "Availability"=>"available"}
            ]
          }
          response
        end
      end
    end
  end
end
