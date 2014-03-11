# coding: utf-8

module Fog
  module Volume
    class SakuraCloud
      class Real
        def list_archives(options = {})
          request(
            :headers => {
              'Authorization' => "Basic #{@auth_encord}"
            },
            :method => 'GET',
            :path => "#{Fog::SakuraCloud::SAKURACLOUD_API_ENDPOINT}/archive"
          )
        end
      end

      class Mock
        def list_archives(options = {})
          response = Excon::Response.new
          response.status = 200
          response.body = {
          "Archives" =>
            [
            {"Index"=>0,
              "ID"=>112500514887,
              "Name"=>"CentOS 5.10 64bit (基本セット)",
              "Availability"=>"available",
              "SizeMB"=>20480,
              "Plan"=>{"ID"=>2, "StorageClass"=>"iscsi1204", "Name"=>"標準プラン"}
            },
            {"Index"=>1,
              "ID"=>112500571575,
              "Name"=>"CentOS 6.5 64bit (基本セット)",
              "Availability"=>"available",
              "SizeMB"=>102400,
              "Plan"=>{"ID"=>2, "StorageClass"=>"iscsi1204", "Name"=>"標準プラン"}
            }
            ]
          }
          response
        end
      end
    end
  end
end
