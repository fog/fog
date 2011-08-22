module Fog
  module Storage
    class AWS
      class Real

        # Change access control list for an S3 object to a canned value
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to modify
        # * object_name<~String> - name of object to get access control list for
        # * acl<~String> - Permissions, must be in ['private', 'public-read', 'public-read-write', 'authenticated-read']
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTObjectPUTacl.html

        def put_object_canned_acl(bucket_name, object_name, acl)
          query = { 'acl' => nil }
          if !['private', 'public-read', 'public-read-write', 'authenticated-read'].include?(acl)
            raise Excon::Errors::BadRequest.new('invalid x-amz-acl')
          end
          request({
            :body     => "",
            :expects  => 200,
            :headers  => { 
              'x-amz-acl' => acl,
              'Content-MD5' => Base64.encode64(Digest::MD5.digest('')).strip,
              'Content-Type' => 'application/json',
              'Date' => Fog::Time.now.to_date_header
            },
            :host     => "#{bucket_name}.#{@host}",
            :method   => 'PUT',
            :path     => CGI.escape(object_name),
            :query    => query
          })
        end

      end
    end
  end
end
