module Fog
  module Storage
    class Rackspace

      class Real

        # Get details for object
        #
        # ==== Parameters
        # * container<~String> - Name of container to look in
        # * object<~String> - Name of object to look for
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def get_object(container, object, &block)
          params = {
            :expects  => 200,
            :method   => 'GET',
            :path     => "#{Fog::Rackspace.escape(container)}/#{Fog::Rackspace.escape(object)}"
          }

          if block_given?
            params[:response_block] = block
          end

          request(params, false)
        end

      end

      class Mock
        def get_object(container, object, &block)
          c = mock_container! container
          o = c.mock_object! object

          body, size = "", 0

          # Recognize an X-Object-Manifest header.
          prefix = o.large_object_prefix
          if prefix
            # Concatenate the contents and sizes of each matching object.
            # Note that cname and oprefix are already escaped.
            cname, oprefix = prefix.split('/', 2)

            target_container = data[cname]
            if target_container
              target_container.objects.each do |name, obj|
                next unless name.start_with? oprefix
                body << obj.body
                size += obj.bytes
              end
            end
          elsif o.static_manifest
            segments = Fog::JSON.decode(o.body)
            segments.each do |segment|
              cname, oname = segment['path'].split('/', 2)

              target_container = mock_container cname
              next unless target_container

              target_object = target_container.mock_object oname
              next unless target_object

              body << target_object.body
              size += target_object.bytes
            end
          else
            body = o.body
            size = o.bytes
          end

          if block_given?
            # Just send it all in one chunk.
            block.call(body, 0, size)
          end

          # TODO set headers
          response = Excon::Response.new
          response.body = body
          response
        end
      end

    end
  end
end
