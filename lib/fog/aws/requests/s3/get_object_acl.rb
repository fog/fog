module Fog
  module AWS
    module S3
      class Real

        # Get access control list for an S3 object
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket containing object
        # * object_name<~String> - name of object to get access control list for
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
        def get_object_acl(bucket_name, object_name)
          unless bucket_name
            raise ArgumentError.new('bucket_name is required')
          end
          unless object_name
            raise ArgumentError.new('object_name is required')
          end
          request({
            :expects    => 200,
            :headers    => {},
            :host       => "#{bucket_name}.#{@host}",
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::Parsers::AWS::S3::AccessControlList.new,
            :path       => CGI.escape(object_name),
            :query      => 'acl'
          })
        end

      end

      class Mock

        def get_object_acl(bucket_name, object_name)
          raise MockNotImplemented.new("Contributions welcome!")
        end

      end
    end
  end
end
