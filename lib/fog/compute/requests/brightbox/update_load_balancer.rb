module Fog
  module Compute
    class Brightbox
      class Real

        def update_load_balancer(identifier, options = {})
          return nil if identifier.nil? || identifier == ""
          return nil if options.empty? || options.nil?
          request(
            :expects  => [202],
            :method   => 'PUT',
            :path     => "/1.0/load_balancers/#{identifier}",
            :headers  => {"Content-Type" => "application/json"},
            :body     => MultiJson.encode(options)
          )
        end

      end
    end
  end
end