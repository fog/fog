module Fog
  module Compute
    class Serverlove
      class Real
        def update_server(identifier, options)
          return nil if identifier.nil? || identifier == ""
          return nil if options.empty? || options.nil?
          request(:method => "post", :path => "/servers/#{identifier}/set", :expects => 200, :options => options)
        end
      end
    end
  end
end
