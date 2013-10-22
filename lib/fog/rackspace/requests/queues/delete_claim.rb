module Fog
  module Rackspace
    class Queues
      class Real
        def delete_claim(queue_name, claim_id)
          request(
            :expects => 204,
            :method => 'DELETE',
            :path => "queues/#{queue_name}/claims/#{claim_id}"
          )
        end
      end
    end
  end
end
