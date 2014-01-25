# coding: utf-8

module Fog
  module Volume
    class SakuraCloud
      class Real
        def list_plans(options = {})
          request(
            :headers => {
              'Authorization' => "Basic #{@auth_encord}"
            },
            :method => 'GET',
            :path => "#{Fog::SakuraCloud::SAKURACLOUD_API_ENDPOINT}/product/disk"
          )
        end
      end

      class Mock
        def list_plans(options = {})
          response = Excon::Response.new
          response.status = 200
          response.body = {
          "DiskPlans" =>
            [
            {"Index"=>0,
              "ID"=>4,
              "Name"=>"SSDプラン",
              "Availability"=>"available"},
            {"Index"=>1,
              "ID"=>2,
              "Name"=>"標準プラン",
              "Availability"=>"available"}
            ]
          }
          response
        end
      end
    end
  end
end
