module Fog
  module Storage
    class Rackspace
      class Real
        # Create a new dynamic large object manifest
        #
        # Creates an object with a +X-Object-Manifest+ header that specifies the common prefix ("<container>/<prefix>")
        # for all uploaded segments. Retrieving the manifest object streams all segments matching this prefix.
        # Segments must sort in the order they should be concatenated. Note that any future objects stored in the container
        # along with the segments that match the prefix will be included when retrieving the manifest object.
        #
        # All segments must be stored in the same container, but may be in a different container than the manifest object.
        # The default +X-Object-Manifest+ header is set to "+container+/+object+", but may be overridden in +options+
        # to specify the prefix and/or the container where segments were stored.
        # If overridden, names should be CGI escaped (excluding spaces) if needed (see {Fog::Rackspace.escape}).
        #
        # @param container [String] Name for container where +object+ will be stored. Should be < 256 bytes and must not contain '/'
        # @param object [String] Name for manifest object.
        # @param options [Hash] Config headers for +object+.
        # @option options [String] 'X-Object-Manifest' ("container/object") "<container>/<prefix>" for segment objects.
        #
        # @raise [Fog::Storage::Rackspace::NotFound] HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        # @raise [Excon::Errors::Unauthorized]
        #
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/Large_Object_Creation-d1e2019.html
        def put_dynamic_obj_manifest(container, object, options = {})
          path = "#{Fog::Rackspace.escape(container)}/#{Fog::Rackspace.escape(object)}"
          headers = {'X-Object-Manifest' => path}.merge(options)
          request(
            :expects  => 201,
            :headers  => headers,
            :method   => 'PUT',
            :path     => path
          )
        end
      end

      class Mock
        def put_dynamic_obj_manifest(container, object, options = {})
          path = "#{Fog::Rackspace.escape(container)}/#{Fog::Rackspace.escape(object)}"

          # Escape the X-Object-Manifest header to match.
          explicit_manifest = options['X-Object-Manifest']
          if explicit_manifest
            parts = explicit_manifest.split('/', 2)
            explicit_manifest = parts.map { |p| Fog::Rackspace.escape p }.join('/')
          end

          c = mock_container! container
          o = c.add_object object, ''
          o.meta['X-Object-Manifest'] = explicit_manifest || path

          response = Excon::Response.new
          response.status = 201
          response
        end
      end
    end
  end
end
