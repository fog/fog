module Fog
  module Storage
    class Rackspace
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
        # * options<~Hash> - config headers for object. Defaults to #{}.
        # * block<~Proc> - chunker
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def put_object(container, object, data, options = {}, &block)
          data = Fog::Storage.parse_data(data)
          headers = data[:headers].merge!(options)

          params = block_given? ? { :request_block => block } : { :body => data[:body] }

          params.merge!(
            :expects    => 201,
            :idempotent => !params[:request_block],
            :headers    => headers,
            :method     => 'PUT',
            :path       => "#{Fog::Rackspace.escape(container)}/#{Fog::Rackspace.escape(object)}"
          )

          request(params)
        end
      end
    end
  end
end
