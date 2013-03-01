module Fog
  module HP
    class DNS

      class Real
        def create_domain(name, email)
          data = {
              name: name,
              email:email
          }
          request(
              :body    => MultiJson.encode(data),
              :expects => 200,
              :method  => 'POST',
              :path    => 'domains.json'
          )
        end
      end

      class Mock
        def create_domain(name,email)
          response = Excon::Response.new
          response.status = 200

          data = {
              id : SecureRandom.uuid,
              name : "domain1.com.",
              ttl : 3600,
              serial : 1351800588,
              email : "nsadmin@example.org",
              created_at : "2012-11-01T20:09:48.094457"
          }
          response.body = data
          response
        end
      end
    end
  end
end