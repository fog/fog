module Fog
  module Storage
    class HP
      class Real
        # Delete a shared object
        #
        # ==== Parameters
        # * shared_object_url<~String> - Url of the shared object
        #
        def delete_shared_object(shared_object_url)
          # split up the shared object url
          uri = URI.parse(shared_object_url)
          path   = uri.path

          response = shared_request(
            :expects  => 204,
            :method   => 'DELETE',
            :path     => path
          )
          response
        end
      end

      class Mock # :nodoc:all
        def delete_shared_object(shared_object_url)
          response = Excon::Response.new
          response.status = 204
          response
        end
      end
    end
  end
end
