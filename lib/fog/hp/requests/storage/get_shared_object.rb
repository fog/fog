module Fog
  module Storage
    class HP
      class Real

        # Get details for a shared object
        #
        # ==== Parameters
        # * shared_object_url<~String> - Url of the shared object
        #
        def get_shared_object(shared_object_url, &block)
          # split up the shared object url
          uri = URI.parse(shared_object_url)
          path   = uri.path

          if block_given?
            response = shared_request(
              :response_block  => block,
              :expects  => 200,
              :method   => 'GET',
              :path     => path
            )
          else
            response = shared_request({
              :block  => block,
              :expects  => 200,
              :method   => 'GET',
              :path     => path
            }, false, &block)
          end
          response
        end

      end

      class Mock # :nodoc:all

        def get_shared_object(shared_object_url, &block)

        end

      end

    end
  end
end
