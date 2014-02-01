# coding: utf-8

module Fog
  module Volume
    class SakuraCloud
      class Real
        def list_disks(options = {})
          request(
            :headers => {
              'Authorization' => "Basic #{@auth_encord}"
            },
            :method => 'GET',
            :path => "#{Fog::SakuraCloud::SAKURACLOUD_API_ENDPOINT}/disk"
          )
        end
      end

      class Mock
        def list_disks(options = {})
          response = Excon::Response.new
          response.status = 200
          response.body = {
          "Disks" =>
            [
            {"Index" => 0,
              "ID" =>112600053890,
              "Name" =>"foober1",
              "Connection" => "virtio",
              "Availability"=>"available",
              "SizeMB"=>20480,
              "Plan"=> {},
              "SourceDisk" => nil,
              "SourceArchive" => {}},
            {"Index" => 1,
              "ID" =>112600053891,
              "Name" =>"foober2",
              "Connection"  => "virtio",
              "Availability"=>"available",
              "SizeMB"=>20480,
              "Plan"=> {},
              "SourceDisk" => nil,
              "SourceArchive" => {}}
            ]
          }
          response
        end
      end
    end
  end
end
