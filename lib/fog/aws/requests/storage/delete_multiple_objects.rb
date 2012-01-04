module Fog
  module Storage
    class AWS
      class Real

        require 'fog/aws/parsers/storage/delete_multiple_objects'

        # Delete multiple objects from S3
        #
        # ==== Parameters
        # * bucket_name<~String> - Name of bucket containing object to delete
        # * object_names<~Array> - Array of object names to delete
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'DeleteResult'<~Array>:
        #       * 'Deleted'<~Hash>:
        #         * 'Key'<~String> - Name of the object that was deleted
        #         * 'VersionId'<~String> - ID for the versioned onject in case of a versioned delete
        #         * 'DeleteMarker'<~Boolean> - Indicates if the request accessed a delete marker
        #         * 'DeleteMarkerVersionId'<~String> - Version ID of the delete marker accessed
        #       * 'Error'<~Hash>:
        #         * 'Key'<~String> - Name of the object that failed to be deleted
        #         * 'VersionId'<~String> - ID of the versioned object that was attempted to be deleted
        #         * 'Code'<~String> - Status code for the result of the failed delete
        #         * 'Message'<~String> - Error description
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonS3/latest/API/multiobjectdeleteapi.html

        def delete_multiple_objects(bucket_name, object_names, options = {})
          data = "<Delete>"
          data << "<Quiet>true</Quiet>" if options.delete(:quiet)
          object_names.each do |object_name|
            data << "<Object>"
            data << "<Key>#{object_name}</Key>"
            data << "</Object>"
          end
          data << "</Delete>"

          headers = options
          headers['Content-Length'] = data.length
          headers['Content-MD5'] = Base64.encode64(Digest::MD5.digest(data)).strip

          request({
            :body       => data,
            :expects    => 200,
            :headers    => headers,
            :host       => "#{bucket_name}.#{@host}",
            :method     => 'POST',
            :parser     => Fog::Parsers::Storage::AWS::DeleteMultipleObjects.new,
            :query      => {'delete' => nil}
          })
        end

      end
    end
  end
end

