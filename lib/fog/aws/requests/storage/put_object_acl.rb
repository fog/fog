module Fog
  module Storage
    class AWS
      class Real

        require 'fog/aws/requests/storage/hash_to_acl'

        # Change access control list for an S3 object
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to modify
        # * object_name<~String> - name of object to get access control list for
        # * acl<~Hash>:
        #   * Owner<~Hash>:
        #     * ID<~String>: id of owner
        #     * DisplayName<~String>: display name of owner
        #   * AccessControlList<~Array>:
        #     * Grantee<~Hash>:
        #         * 'DisplayName'<~String> - Display name of grantee
        #         * 'ID'<~String> - Id of grantee
        #       or
        #         * 'EmailAddress'<~String> - Email address of grantee
        #       or
        #         * 'URI'<~String> - URI of group to grant access for
        #     * Permission<~String> - Permission, in [FULL_CONTROL, WRITE, WRITE_ACP, READ, READ_ACP]
        # * acl<~String> - Permissions, must be in ['private', 'public-read', 'public-read-write', 'authenticated-read']
        # * options<~Hash>:
        #   * 'versionId'<~String> - specify a particular version to retrieve
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTObjectPUTacl.html

        def put_object_acl(bucket_name, object_name, acl, options = {})
          query = {'acl' => nil}
          if version_id = options.delete('versionId')
            query['versionId'] = version_id
          end
          
          data = ""
          headers = {}
          
          if acl.is_a?(Hash)
            data = Fog::Storage::AWS.hash_to_acl(acl)
          else
            if !['private', 'public-read', 'public-read-write', 'authenticated-read'].include?(acl)
              raise Excon::Errors::BadRequest.new('invalid x-amz-acl')
            end
            headers['x-amz-acl'] = acl
          end

          headers['Content-MD5'] = Base64.encode64(Digest::MD5.digest(data)).strip
          headers['Content-Type'] = 'application/json'
          headers['Date'] = Fog::Time.now.to_date_header
          
          request({
            :body     => data,
            :expects  => 200,
            :headers  => headers,
            :host     => "#{bucket_name}.#{@host}",
            :method   => 'PUT',
            :path       => CGI.escape(object_name),
            :query    => query
          })
        end
      end
      
      class Mock
        def put_object_acl(bucket_name, object_name, acl, options = {})
          if acl.is_a?(Hash)
            self.data[:acls][:object][bucket_name][object_name] = Fog::Storage::AWS.hash_to_acl(acl)
          else
            if !['private', 'public-read', 'public-read-write', 'authenticated-read'].include?(acl)
              raise Excon::Errors::BadRequest.new('invalid x-amz-acl')
            end
            self.data[:acls][:object][bucket_name][object_name] = acl
          end        
        end
      end

    end
  end
end
