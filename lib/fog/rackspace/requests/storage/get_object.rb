module Fog
  module Storage
    class Rackspace
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
            :block    => block,
            :expects  => 200,
            :method   => 'GET',
            :path     => "#{Fog::Rackspace.escape(container)}/#{Fog::Rackspace.escape(object)}"
          }), false)
        end

      end
    end
  end
end
