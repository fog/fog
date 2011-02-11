module Fog
  module Brightbox
    class Compute
      class Real

        def update_load_balancer(identifier, options = {})
          return nil if identifier.nil? || identifier == ""
          return nil if options.empty? || options.nil?
          request(
            :expects  => [202],
            :method   => 'PUT',
            :path     => "/1.0/load_balancers/#{identifier}",
            :headers  => {"Content-Type" => "application/json"},
            :body     => options.to_json
          )
        end

      end
    end
  end
end