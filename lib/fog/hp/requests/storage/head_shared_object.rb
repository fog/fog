module Fog
  module Storage
    class HP
      class Real
        # Get headers for shared object
        #
        # ==== Parameters
        # * * shared_object_url<~String> - Url of the shared object
        #
        def head_shared_object(shared_object_url)
          # split up the shared object url
          uri = URI.parse(shared_object_url)
          path   = uri.path

          response = shared_request({
            :expects  => 200,
            :method   => 'HEAD',
            :path     => path
          }, false)
          response
        end
      end

      class Mock # :nodoc:all
        def head_shared_object(shared_object_url)
          response = get_shared_object(shared_object_url)
          response.body = nil
          response.status = 200
          response
        end
      end
    end
  end
end
