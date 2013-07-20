module Fog
  module Rackspace
    class Queues
      class Real
        def update_claim(queue_name, claim_id, ttl)
          body = {
            :ttl => ttl
          }
          request(
            :body => Fog::JSON.encode(body),
            :expects => 204,
            :method => 'PATCH',
            :path => "queues/#{queue_name}/claims/#{claim_id}"
          )
        end
      end
    end
  end
end
