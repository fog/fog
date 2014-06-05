# coding: utf-8

module Fog
  module Volume
    class SakuraCloud
      class Real
        def delete_disk( id )
          request(
            :headers => {
              'Authorization' => "Basic #{@auth_encord}"
            },
            :expects  => [200],
            :method => 'DELETE',
            :path => "#{Fog::SakuraCloud::SAKURACLOUD_API_ENDPOINT}/disk/#{id}"
          )
        end
      end # Real

      class Mock
        def delete_disk( id )
          response = Excon::Response.new
          response.status = 200
          response.body = {
          }
          response
        end
      end
    end # SakuraCloud
  end # Volume
end # Fog
