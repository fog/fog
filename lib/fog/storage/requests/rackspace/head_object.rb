module Fog
  module Rackspace
    class Storage
      class Real

        # Get headers for object
        #
        # ==== Parameters
        # * container<~String> - Name of container to look in
        # * object<~String> - Name of object to look for
        #
        def head_object(container, object)
          response = request({
            :expects  => 200,
            :method   => 'HEAD',
            :path     => "#{URI.escape(container)}/#{URI.escape(object)}"
          }, false)
          response
        end

      end
    end
  end
end
