module Fog
  module HP
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
            :path     => "#{escape_name(container)}/#{escape_name(object)}"
          }, false)
          response
        end

      end

      class Mock # :nodoc:all

        def head_object(container_name, object_name, options = {})
          response = get_object(container_name, object_name, options)
          response.body = nil
          response
        end

      end

    end
  end
end
