module Fog
  module Storage
    class InternetArchive
      class Real
        require 'fog/internet_archive/parsers/storage/delete_multiple_objects'

        # Delete multiple objects from S3
        # @note For versioned deletes, options should include a version_ids hash, which
        #     maps from filename to an array of versions.
        #     The semantics are that for each (object_name, version) tuple, the
        #     caller must insert the object_name and an associated version (if
        #     desired), so for n versions, the object must be inserted n times.
        #
        # @param bucket_name [String] Name of bucket containing object to delete
        # @param object_names [Array]  Array of object names to delete
        #
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * DeleteResult [Array]:
        #       * Deleted [Hash]:
        #         * Key [String] - Name of the object that was deleted
        #         * VersionId [String] - ID for the versioned onject in case of a versioned delete
        #         * DeleteMarker [Boolean] - Indicates if the request accessed a delete marker
        #         * DeleteMarkerVersionId [String] - Version ID of the delete marker accessed
        #       * Error [Hash]:
        #         * Key [String] - Name of the object that failed to be deleted
        #         * VersionId [String] - ID of the versioned object that was attempted to be deleted
        #         * Code [String] - Status code for the result of the failed delete
        #         * Message [String] - Error description
        #
        # @see http://docs.amazonwebservices.com/AmazonS3/latest/API/multiobjectdeleteapi.html

        def delete_multiple_objects(bucket_name, object_names, options = {})
          data = "<Delete>"
          data << "<Quiet>true</Quiet>" if options.delete(:quiet)
          object_names.each do |object_name|
            data << "<Object>"
            data << "<Key>#{CGI.escapeHTML(object_name)}</Key>"
            data << "</Object>"
          end
          data << "</Delete>"

          headers = options
          headers['Content-Length'] = data.length
          headers['Content-MD5'] = Base64.encode64(Digest::MD5.digest(data)).
                                   gsub("\n", '')

          request({
            :body       => data,
            :expects    => 200,
            :headers    => headers,
            :host       => "#{bucket_name}.#{@host}",
            :method     => 'POST',
            :parser     => Fog::Parsers::Storage::InternetArchive::DeleteMultipleObjects.new,
            :query      => {'delete' => nil}
          })
        end
      end

      class Mock # :nodoc:all
        def delete_multiple_objects(bucket_name, object_names, options = {})
          response = Excon::Response.new
          if bucket = self.data[:buckets][bucket_name]
            response.status = 200
            response.body = { 'DeleteResult' => [] }
            object_names.each do |object_name|
              response.body['DeleteResult'] << delete_object_helper(bucket,
                                                                object_name)
            end
          else
            response.status = 404
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
          response
        end

        private

        def delete_object_helper(bucket, object_name)
          response = { 'Deleted' => {} }
          bucket[:objects].delete(object_name)
          response['Deleted'] = { 'Key' => object_name }
          response
        end
      end
    end
  end
end
