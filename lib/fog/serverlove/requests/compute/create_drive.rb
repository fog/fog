module Fog
  module Compute
    class Serverlove
      class Real

        def create_drive(options)
          return nil if options.empty? || options.nil?
          request(:method => "post", :path => "/drives/create", :expects => 200, :options => options)
        end

      end
    end
  end
end
