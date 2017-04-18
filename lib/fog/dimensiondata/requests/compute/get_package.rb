require 'uri'

module Fog
  module Compute
    class Joyent
      class Mock
        def get_package(name)
          if pkg = self.data[:packages][name]
            response = Excon::Response.new
            response.body = pkg
            response.status = 200
            response
          else
            raise Excon::Errors::NotFound
          end
        end
      end

      class Real
        def get_package(name)
          name = URI.escape(name)
          request(
            :method => "GET",
            :path => "/my/packages/#{name}",
            :expects => 200,
            :idempotent => true
          )
        end
      end
    end
  end
end
