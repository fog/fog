module Fog
  module Storage
    class OpenStack
      class Real

        def url
          "#{@scheme}://#{@host}:#{@port}#{@path}"
        end

        # Get public_url for an object
        #
        # ==== Parameters
        # * container<~String> - Name of container to look in
        # * object<~String> - Name of object to look for
        #
        def public_url(container=nil, object=nil)
          public_url = nil
          unless container.nil?
            if object.nil?
              # return container public url
              public_url = "#{url}/#{Fog::OpenStack.escape(container)}"
            else
              # return object public url
              public_url = "#{url}/#{Fog::OpenStack.escape(container)}/#{Fog::OpenStack.escape(object)}"
            end
          end
          public_url
        end
      end
    end
  end
end
