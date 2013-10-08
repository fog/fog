module Fog
  module Rackspace
    class Queues
      class Real
        def get_claim(queue_name, claim_id)
          request(
            :expects => 200,
            :method => 'GET',
            :path => "queues/#{queue_name}/claims/#{claim_id}"
          )
        end
      end
    end
  end
end
