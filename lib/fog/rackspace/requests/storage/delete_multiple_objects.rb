module Fog
  module Storage
    class Rackspace
      class Real
        # Deletes multiple objects or containers with a single request.
        #
        # To delete objects from a single container, +container+ may be provided
        # and +object_names+ should be an Array of object names within the container.
        #
        # To delete objects from multiple containers or delete containers,
        # +container+ should be +nil+ and all +object_names+ should be prefixed with a container name.
        #
        # Containers must be empty when deleted. +object_names+ are processed in the order given,
        # so objects within a container should be listed first to empty the container.
        #
        # Up to 10,000 objects may be deleted in a single request.
        # The server will respond with +200 OK+ for all requests.
        # +response.body+ must be inspected for actual results.
        #
        # @example Delete objects from a container
        #   object_names = ['object', 'another/object']
        #   conn.delete_multiple_objects('my_container', object_names)
        #
        # @example Delete objects from multiple containers
        #   object_names = ['container_a/object', 'container_b/object']
        #   conn.delete_multiple_objects(nil, object_names)
        #
        # @example Delete a container and all it's objects
        #   object_names = ['my_container/object_a', 'my_container/object_b', 'my_container']
        #   conn.delete_multiple_objects(nil, object_names)
        #
        # @param container [String,nil] Name of container.
        # @param object_names [Array<String>] Object names to be deleted.
        # @param options [Hash] Additional request headers.
        #
        # @return [Excon::Response]
        #   * body [Hash] - Results of the operation.
        #     * "Number Not Found" [Integer] - Number of missing objects or containers.
        #     * "Response Status" [String] - Response code for the subrequest of the last failed operation.
        #     * "Errors" [Array<object_name, response_status>]
        #       * object_name [String] - Object that generated an error when the delete was attempted.
        #       * response_status [String] - Response status from the subrequest for object_name.
        #     * "Number Deleted" [Integer] - Number of objects or containers deleted.
        #     * "Response Body" [String] - Response body for "Response Status".
        #
        # @raise [Fog::Storage::Rackspace::NotFound] HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        # @raise [Excon::Errors::Unauthorized] HTTP 401
        #
        # @see http://docs.rackspace.com/files/api/v1/cf-devguide/content/Bulk_Delete-d1e2338.html
        def delete_multiple_objects(container, object_names, options = {})
          body = object_names.map do |name|
            object_name = container ? "#{ container }/#{ name }" : name
            URI.encode(object_name)
          end.join("\n")

          response = request({
            :expects  => 200,
            :method   => 'DELETE',
            :headers  => options.merge('Content-Type' => 'text/plain',
                                       'Accept' => 'application/json'),
            :body     => body,
            :query    => { 'bulk-delete' => true }
          }, false)
          response.body = Fog::JSON.decode(response.body)
          response
        end
      end

      class Mock
        def delete_multiple_objects(container, object_names, options = {})
          results = {
            "Number Not Found" => 0,
            "Response Status" => "200 OK",
            "Response Body" => "",
            "Errors" => [],
            "Number Deleted" => 0
          }

          object_names.each do |name|
            if container
              cname, oname = container, name
            else
              cname, oname = name.split('/', 2)
            end

            c = mock_container cname
            if c.nil?
              # Container not found
              results["Number Not Found"] += 1
              next
            end

            if oname.nil?
              # No object name specified; delete the container if it's nonempty
              unless c.empty?
                results["Response Status"] = "400 Bad Request"
                results["Errors"] << [cname, "409 Conflict"]
                next
              end

              remove_container cname
              results["Number Deleted"] += 1
              next
            end

            o = c.mock_object oname
            if o.nil?
              # Object not found.
              results["Number Not Found"] += 1
              next
            end

            c.remove_object oname
            results["Number Deleted"] += 1
          end

          response = Excon::Response.new
          response.status = 200
          response.body = results
          response
        end
      end
    end
  end
end
