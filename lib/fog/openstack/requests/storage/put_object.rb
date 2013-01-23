module Fog
  module Storage
    class OpenStack
      class Real

        # Create a new object
        #
        # ==== Parameters
        # * container<~String> - Name for container, should be < 256 bytes and must not contain '/'
        # * object<~String> - Name for object
        # * data<~String|File> - data to upload
        # * options<~Hash> - config headers for object. Defaults to {}.
        #
        def put_object(container, object, data, options = {})
          data = Fog::Storage.parse_data(data)
          headers = data[:headers].merge!(options)
          request(
            :body       => data[:body],
            :expects    => 201,
            :idempotent => true,
            :headers    => headers,
            :method     => 'PUT',
            :path       => "#{Fog::OpenStack.escape(container)}/#{Fog::OpenStack.escape(object)}"
          )
        end

      end
    end
  end
end
