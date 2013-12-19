module Fog
  module Storage
    class Rackspace

      class Real

        # Get headers for object
        #
        # ==== Parameters
        # * container<~String> - Name of container to look in
        # * object<~String> - Name of object to look for
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def head_object(container, object)
          request({
            :expects  => 200,
            :method   => 'HEAD',
            :path     => "#{Fog::Rackspace.escape(container)}/#{Fog::Rackspace.escape(object)}"
          }, false)
        end

      end

      class Mock
        def head_object(container, object)
          c = mock_container! container
          o = c.mock_object! object

          headers = o.to_headers

          prefix = o.large_object_prefix
          if prefix
            # Concatenate the contents and sizes of each matching object.
            # Note that cname and oprefix are already escaped.
            cname, oprefix = prefix.split('/', 2)

            target_container = data[cname]
            if target_container
              ohash = target_container.objects
              matching = ohash.keys.select { |k| k.start_with? oprefix }
              hashes = matching.sort.map { |k| ohash[k].hash }

              headers['Etag'] = "\"#{Digest::MD5.hexdigest(hashes.join)}\""
            end
          elsif o.static_manifest
            hashes, length = [], 0
            segments = Fog::JSON.decode(o.body)
            segments.each do |segment|
              cname, oname = segment['path'].split('/', 2)

              target_container = mock_container cname
              next unless target_container

              target_object = target_container.mock_object oname
              next unless target_object

              hashes << target_object.hash
              length += target_object.bytes
            end

            headers['Etag'] = "\"#{Digest::MD5.hexdigest(hashes.join)}\""
            headers['Content-Length'] = length.to_s
            headers['X-Static-Large-Object'] = "True"
          end

          response = Excon::Response.new
          response.status = 200
          response.headers = headers
          response
        end
      end

    end
  end
end
