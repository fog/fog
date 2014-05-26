module Fog
  module Compute
    class Serverlove
      class Real
        def update_image(identifier, options)
          return nil if identifier.nil? || identifier == ""
          return nil if options.empty? || options.nil?
          request(:method => "post", :path => "/drives/#{identifier}/set", :expects => 200, :options => options)
        end
      end
    end
  end
end
