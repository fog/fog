# coding: utf-8

module Fog
  module Volume
    class SakuraCloud
      class Real
        def create_disk( name, plan, sourcearchive )
          body = {
           "Disk" => {
             "Name" => name,
             "SourceArchive" => {
               "ID" => sourcearchive.to_s
              },
              "Plan" => {
                "ID" => plan.to_i
              }
            }
          }

          request(
            :headers => {
              'Authorization' => "Basic #{@auth_encord}"
            },
            :expects  => [202],
            :method => 'POST',
            :path => "#{Fog::SakuraCloud::SAKURACLOUD_API_ENDPOINT}/disk",
            :body => Fog::JSON.encode(body)
          )
        end
      end # Real

      class Mock
        def create_disk( name, plan, sourcearchive )
          response = Excon::Response.new
          response.status = 202
          response.body = {
          }
          response
        end
      end
    end # SakuraCloud
  end # Volume
end # Fog
