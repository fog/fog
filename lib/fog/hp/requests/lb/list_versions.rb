module Fog
  module HP
    class LB
      class Real

        def list_versions
          request(
            :expects => [200, 204],
            :method  => 'GET',
            :path    => "",
            :version => true
          )
        end
      end
      class Mock

        def list_versions
          response        = Excon::Response.new
          response.status = 200
          response.body   = {
            "versions" => [
              {"id" => "v1.1", "links" => [{"href" => "http://api-docs.hpcloud.com", "rel" => "self"}], "status" => "CURRENT", "updated" => "2012-12-18T18:30:02.25Z"}
            ]
          }
          response
        end

      end
    end
  end
end