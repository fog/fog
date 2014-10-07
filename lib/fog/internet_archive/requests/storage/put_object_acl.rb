module Fog
  module Storage
    class InternetArchive
      class Real
        require 'fog/internet_archive/requests/storage/acl_utils'

        # Change access control list for an S3 object
        #
        # @param bucket_name [String] name of bucket to modify
        # @param object_name [String] name of object to get access control list for
        # @param acl [Hash]:
        #   * Owner [Hash]
        #     * ID [String] id of owner
        #     * DisplayName [String] display name of owner
        #   * AccessControlList [Array]
        #     * Grantee [Hash]
        #       * DisplayName [String] Display name of grantee
        #       * ID [String] Id of grantee
        #       or
        #       * EmailAddress [String] Email address of grantee
        #       or
        #       * URI [String] URI of group to grant access for
        #     * Permission [String] Permission, in [FULL_CONTROL, WRITE, WRITE_ACP, READ, READ_ACP]
        # @param acl [String] Permissions, must be in ['private', 'public-read', 'public-read-write', 'authenticated-read']
        # @param options [Hash]
        #
        # @see http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTObjectPUTacl.html

        def put_object_acl(bucket_name, object_name, acl, options = {})
          query = {'acl' => nil}
          data = ""
          headers = {}

          if acl.is_a?(Hash)
            data = Fog::Storage::InternetArchive.hash_to_acl(acl)
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
            self.data[:acls][:object][bucket_name][object_name] = Fog::Storage::InternetArchive.hash_to_acl(acl)
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
