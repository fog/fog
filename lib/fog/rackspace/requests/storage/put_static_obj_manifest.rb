module Fog
  module Storage
    class Rackspace
      class Real
        # Create a new static large object manifest.
        #
        # A static large object is similar to a dynamic large object. Whereas a GET for a dynamic large object manifest
        # will stream segments based on the manifest's +X-Object-Manifest+ object name prefix, a static large object
        # manifest streams segments which are defined by the user within the manifest. Information about each segment is
        # provided in +segments+ as an Array of Hash objects, ordered in the sequence which the segments should be streamed.
        #
        # When the SLO manifest is received, each segment's +etag+ and +size_bytes+ will be verified.
        # The +etag+ for each segment is returned in the response to {#put_object}, but may also be calculated.
        # e.g. +Digest::MD5.hexdigest(segment_data)+
        #
        # The maximum number of segments for a static large object is 1000, and all segments (except the last) must be
        # at least 1 MiB in size. Unlike a dynamic large object, segments are not required to be in the same container.
        #
        # @example
        #   segments = [
        #     { :path => 'segments_container/first_segment',
        #       :etag => 'md5 for first_segment',
        #       :size_bytes => 'byte size of first_segment' },
        #     { :path => 'segments_container/second_segment',
        #       :etag => 'md5 for second_segment',
        #       :size_bytes => 'byte size of second_segment' }
        #   ]
        #   put_static_obj_manifest('my_container', 'my_large_object', segments)
        #
        # @param container [String] Name for container where +object+ will be stored.
        #     Should be < 256 bytes and must not contain '/'
        # @param object [String] Name for manifest object.
        # @param segments [Array<Hash>] Segment data for the object.
        # @param options [Hash] Config headers for +object+.
        #
        # @raise [Fog::Storage::Rackspace::NotFound] HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        # @raise [Excon::Errors::Unauthorized] HTTP 401
        #
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/Uploading_the_Manifext-d1e2227.html
        def put_static_obj_manifest(container, object, segments, options = {})
          request(
            :expects  => 201,
            :method   => 'PUT',
            :headers  => options,
            :body     => Fog::JSON.encode(segments),
            :path     => "#{Fog::Rackspace.escape(container)}/#{Fog::Rackspace.escape(object)}",
            :query    => { 'multipart-manifest' => 'put' }
          )
        end
      end

      class Mock
        def put_static_obj_manifest(container, object, segments, options = {})
          c = mock_container! container

          # Verify paths.
          errors = []
          segments.each do |segment|
            cname, oname = segment[:path].split('/', 2)
            target_container = mock_container(cname)

            raise Fog::Storage::Rackspace::NotFound.new unless target_container

            target_object = target_container.mock_object oname
            unless target_object
              errors << [segment[:path], '404 Not Found']
              next
            end

            unless target_object.hash == segment[:etag]
              errors << [segment[:path], 'Etag Mismatch']
            end

            unless target_object.bytes_used == segment[:size_bytes]
              errors << [segment[:path], 'Size Mismatch']
            end
          end

          unless errors.empty?
            response = Excon::Response.new
            response.status = 400
            response.body = Fog::JSON.encode({ 'Errors' => errors })

            error = Excon::Errors.status_error({}, response)
            raise Fog::Storage::Rackspace::BadRequest.slurp(error)
          end

          data = Fog::JSON.encode(segments)
          o = c.add_object object, data
          o.static_manifest = true

          response = Excon::Response.new
          response.status = 201
          response
        end
      end
    end
  end
end
