module Fog
  module Compute
    class Serverlove
      class Real
        def create_server(options)
          return nil if options.empty? || options.nil?
          request(:method => "post", :path => "/servers/create/stopped", :expects => 200, :options => options)
        end
      end

      class Mock
        def create_server(options = {})
          response = Excon::Response.new
          response.status = 200

          data = {
            'server'       => Fog::Mock.random_numbers(1000000).to_s,
            'name'         => options['name'] || 'Test',
            'cpu'          => options['cpu'] || 1000,
            'persistent'   => options['persistent'] || false,
            'vnc:password' => options['vnc:password'] || 'T35tServER!'
          }

          response.body = data
          response
        end
      end
    end
  end
end
