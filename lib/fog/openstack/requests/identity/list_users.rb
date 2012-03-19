module Fog
  module Identity
    class OpenStack
      class Real
        def list_users
          request(
            :expects => [200, 204],
            :method  => 'GET',
            :path    => 'users'
          )
        end
      end # class Real

      class Mock
        def list_users
          response = Excon::Response.new
          response.status = 200
          response.body = { 'users' => self.data[:users].values }
          response
        end
      end # class Mock
    end # class OpenStack
  end # module Identity
end # module Fog
