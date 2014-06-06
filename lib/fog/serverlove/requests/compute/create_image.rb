module Fog
  module Compute
    class Serverlove
      class Real
        def create_image(options)
          return nil if options.empty? || options.nil?
          request(:method => "post", :path => "/drives/create", :expects => 200, :options => options)
        end
      end

      class Mock
        def create_image(options = {})
          response = Excon::Response.new
          response.status = 200

          data = {
            'drive'     => Fog::Mock.random_numbers(1000000).to_s,
            'name'      => options['name'] || 'Test',
            'size'      => options['size'] || 12345
          }

          response.body = data
          response
        end
      end
    end
  end
end
