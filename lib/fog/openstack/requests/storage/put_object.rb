module Fog
  module Storage
    class OpenStack
      class Real
        # Create a new object
        #
        # When passed a block, it will make a chunked request, calling
        # the block for chunks until it returns an empty string.
        # In this case the data parameter is ignored.
        #
        # ==== Parameters
        # * container<~String> - Name for container, should be < 256 bytes and must not contain '/'
        # * object<~String> - Name for object
        # * data<~String|File> - data to upload
        # * options<~Hash> - config headers for object. Defaults to {}.
        # * block<~Proc> - chunker
        #
        def put_object(container, object, data, options = {}, &block)
          if block_given?
            params = { :request_block => block }
            headers = options
          else
            data = Fog::Storage.parse_data(data)
            headers = data[:headers].merge!(options)
            params = { :body => data[:body] }
          end

          params.merge!(
            :expects    => 201,
            :idempotent => !params[:request_block],
            :headers    => headers,
            :method     => 'PUT',
            :path       => "#{Fog::OpenStack.escape(container)}/#{Fog::OpenStack.escape(object)}"
          )

          request(params)
        end
      end
    end
  end
end
