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

      class Mock
        HeaderOptions = %w{
          Content-Type Access-Control-Allow-Origin Origin Content-Disposition
          Etag Content-Encoding
        }.freeze

        def put_object(container, object, data, options = {}, &block)
          c = mock_container! container

          if block_given?
            data = ""
            loop do
              chunk = yield
              break if chunk.empty?
              data << chunk
            end
          end

          o = c.add_object object, data
          options.keys.each do |k|
            o.meta[k] = options[k].to_s if k =~ /^X-Object-Meta/
            o.meta[k] = options[k] if HeaderOptions.include? k
          end

          # Validate the provided Etag
          etag = o.meta['Etag']
          if etag && etag != o.hash
            c.remove_object object
            raise Fog::Storage::Rackspace::ServiceError.new
          end

          response = Excon::Response.new
          response.status = 201
          response
        end
      end
    end
  end
end
