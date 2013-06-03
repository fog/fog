module Fog
  module Storage
    class OpenStack
      class Real

        # Create a new manifest object
        #
        # ==== Parameters
        # * container<~String> - Name for container, should be < 256 bytes and must not contain '/'
        # * object<~String> - Name for manifest object
        # * options<~Hash>:
        #   * 'segments_container'<~String> - Name of container where segments are stored. +container+ will be used if not given.
        #   * 'segments_prefix'<~String> - Name prefix used for segmented objects. +object+ will be used if not given.
        #
        def put_object_manifest(container, object, options = {})
          path = "#{Fog::OpenStack.escape(container)}/#{Fog::OpenStack.escape(object)}"
          prefix = "#{Fog::OpenStack.escape(options['segments_container'] || container)}/#{Fog::OpenStack.escape(options['segments_prefix'] || object)}"
          request(
            :expects  => 201,
            :headers  => {'X-Object-Manifest' => prefix},
            :method   => 'PUT',
            :path     => path
          )
        end

      end
    end
  end
end
