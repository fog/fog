module Fog
  module Storage
    class HP
      class Real

        # Update or create a container
        #
        # ==== Parameters
        # * container<~String> - Name for container, should be < 256 bytes and must not contain '/'
        #
        def post_container(container, headers = {})
          response = request(
            :expects  => 204,
            :headers  => headers,
            :method   => 'POST',
            :path     => "#{Fog::HP.escape(container)}"
          )
          response
        end

      end

      class Mock # :nodoc:all

        def post_container(container_name, object_name, headers = {})
          if self.data[:containers][container_name].nil?
            raise Fog::Storage::HP::NotFound
          end
          response = Excon::Response.new
          response.status = 204
          response
        end

      end

    end
  end
end
