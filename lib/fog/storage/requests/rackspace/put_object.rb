module Fog
  module Storage
    class Rackspace
      class Real

        # Create a new object
        #
        # ==== Parameters
        # * container<~String> - Name for container, should be < 256 bytes and must not contain '/'
        #
        def put_object(container, object, data, options = {})
          data = Fog::Storage.parse_data(data)
          headers = data[:headers].merge!(options)
          request(
            :body     => data[:body],
            :expects  => 201,
            :headers  => headers,
            :method   => 'PUT',
            :path     => "#{URI.escape(container)}/#{URI.escape(object)}"
          )
        end

      end
    end
  end
end
