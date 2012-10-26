module Fog
  module Storage
    class HP
      class Real

        # Update a shared container
        #
        # ==== Parameters
        # * shared_container_url<~String> - Shared url for the container
        # * options<~Hash> - header options
        #
        def put_shared_container(shared_container_url, options = {})
          # split up the shared container url
          uri = URI.parse(shared_container_url)
          path   = uri.path

          response = shared_request(
            :expects  => [201, 202],
            :headers  => options,
            :method   => 'PUT',
            :path     => path
          )
          response
        end

      end

      class Mock # :nodoc:all

        def put_shared_container(shared_container_url, options = {})
          response = Excon::Response.new
          response.status = 201
          response.headers.merge!(options)
          response
        end
      end

    end
  end
end
