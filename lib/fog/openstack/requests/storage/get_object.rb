module Fog
  module Storage
    class OpenStack
      class Real

        # Get details for object
        #
        # ==== Parameters
        # * container<~String> - Name of container to look in
        # * object<~String> - Name of object to look for
        #
        def get_object(container, object, &block)
          params = {}

          if block_given?
            params[:response_block] = Proc.new
          end

          request(params.merge!({
            :expects  => 200,
            :method   => 'GET',
            :path     => "#{Fog::OpenStack.escape(container)}/#{Fog::OpenStack.escape(object)}"
          }), false)
        end

      end
    end
  end
end
