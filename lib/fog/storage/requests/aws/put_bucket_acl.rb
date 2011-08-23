module Fog
  module Storage
    class AWS
      class Real

        # Change access control list for an S3 bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to modify
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
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketPUTacl.html

        def put_bucket_acl(bucket_name, acl)
          data = ""
          headers = {}
          
          if acl.is_a?(Hash)
            data =
<<-DATA
<AccessControlPolicy>
  <Owner>
    <ID>#{acl['Owner']['ID']}</ID>
    <DisplayName>#{acl['Owner']['DisplayName']}</DisplayName>
  </Owner>
  <AccessControlList>
DATA

            acl['AccessControlList'].each do |grant|
              data << "    <Grant>\n"
              type = case grant['Grantee'].keys.sort
              when ['DisplayName', 'ID']
                'CanonicalUser'
              when ['EmailAddress']
                'AmazonCustomerByEmail'
              when ['URI']
                'Group'
              end
              data << "      <Grantee xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:type=\"#{type}\">\n"
              for key, value in grant['Grantee']
                data << "        <#{key}>#{value}</#{key}>\n"
              end
              data << "      </Grantee>\n"
              data << "      <Permission>#{grant['Permission']}</Permission>\n"
              data << "    </Grant>\n"
            end

            data <<
<<-DATA
  </AccessControlList>
</AccessControlPolicy>
DATA
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
            :query    => {'acl' => nil}
          })
        end

      end
    end
  end
end
