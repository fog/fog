module Fog
  module Rackspace
    module Files
      class Real

        # Get details for object
        #
        # ==== Parameters
        # * container<~String> - Name of container to look in
        # * object<~String> - Name of object to look for
        #
        def get_object(container, object, &block)
          response = storage_request({
            :block    => block,
            :expects  => 200,
            :method   => 'GET',
            :path     => "#{CGI.escape(container)}/#{CGI.escape(object)}"
          }, false, &block)
          response
        end

      end

      class Mock

        def get_object(container, object)
          raise MockNotImplemented.new("Contributions welcome!")
        end

      end
    end
  end
end
