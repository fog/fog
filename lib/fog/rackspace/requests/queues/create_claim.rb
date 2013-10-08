module Fog
  module Rackspace
    class Queues
      class Real
        def create_claim(queue_name, ttl, grace, options = {})
          body = {
            :ttl => ttl,
            :grace => grace
          }

          query = {}
          query[:limit] = options[:limit] if options.has_key? :limit
          request(
            :body => Fog::JSON.encode(body),
            :expects => [200, 201, 204],
            :method => 'POST',
            :path => "queues/#{queue_name}/claims",
            :query => query
          )
        end
      end
    end
  end
end
