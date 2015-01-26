module Fog
  module Storage
    class OpenStack
      class Real

        # Get public_url for an object
        #
        # ==== Parameters
        # * container<~String> - Name of container to look in
        # * object<~String> - Name of object to look for
        #
        def public_url(container=nil, object=nil)
          return nil if container.nil?
          u = "#{url}/#{Fog::OpenStack.escape(container)}"
          u << "/#{Fog::OpenStack.escape(object)}" unless object.nil?
          u
        end

        private

        def url
          "#{@scheme}://#{@host}:#{@port}#{@path}"
        end

      end
    end
  end
end
