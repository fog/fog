unless Fog.mocking?

  module Fog
    module Rackspace
      class Files

        # Create a new object
        #
        # ==== Parameters
        # * container<~String> - Name for container, should be < 256 bytes and must not contain '/'
        #
        def put_object(container, object, data)
          data = parse_data(data)
          response = storage_request(
            :body     => data[:body],
            :expects  => 201,
            :headers  => data[:headers],
            :method   => 'PUT',
            :path     => "#{CGI.escape(container)}/#{CGI.escape(object)}"
          )
          response
        end

      end
    end
  end

else

  module Fog
    module Rackspace
      class Servers

        def put_object(container, object, data)
          raise MockNotImplemented.new("Contributions welcome!")
        end

      end
    end
  end

end
