module Fog
  module Storage
    class AWS
      class Real

        require 'fog/aws/parsers/storage/access_control_list'

        # Get access control list for an S3 bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to get access control list for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'AccessControlPolicy'<~Hash>
        #       * 'Owner'<~Hash>:
        #         * 'DisplayName'<~String> - Display name of object owner
        #         * 'ID'<~String> - Id of object owner
        #       * 'AccessControlList'<~Array>:
        #         * 'Grant'<~Hash>:
        #           * 'Grantee'<~Hash>:
        #              * 'DisplayName'<~String> - Display name of grantee
        #              * 'ID'<~String> - Id of grantee
        #             or
        #              * 'URI'<~String> - URI of group to grant access for
        #           * 'Permission'<~String> - Permission, in [FULL_CONTROL, WRITE, WRITE_ACP, READ, READ_ACP]
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketGETacl.html

        def get_bucket_acl(bucket_name)
          unless bucket_name
            raise ArgumentError.new('bucket_name is required')
          end
          request({
            :expects    => 200,
            :headers    => {},
            :host       => "#{bucket_name}.#{@host}",
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::Parsers::Storage::AWS::AccessControlList.new,
            :query      => {'acl' => nil}
          })
        end

      end

      class Mock # :nodoc:all

        require 'fog/aws/requests/storage/acl_utils'

        def get_bucket_acl(bucket_name)
          response = Excon::Response.new
          if acl = self.data[:acls][:bucket][bucket_name]
            response.status = 200
            if acl.is_a?(String)
              response.body = Fog::Storage::AWS.acl_to_hash(acl)
            else
              response.body = acl
            end
          else
            response.status = 404
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
          response
        end

      end
    end
  end
end
