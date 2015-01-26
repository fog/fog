module Fog
  module HP
    class LB
      class Real
        def list_versions
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => ''
          )
        end
      end
      class Mock
        def list_versions
          response        = Excon::Response.new
          versions       = self.data[:versions].values
          response.status = 200
          response.body   = { 'versions' => versions }
          response
        end
      end
    end
  end
end
