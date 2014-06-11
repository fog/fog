module Fog
  module Storage
    class InternetArchive
      class Real
        require 'fog/internet_archive/parsers/storage/access_control_list'

        # Get access control list for an S3 object
        #
        # @param bucket_name [String] name of bucket containing object
        # @param object_name [String] name of object to get access control list for
        # @param options [Hash]
        #
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * [AccessControlPolicy [Hash]:
        #       * Owner [Hash]:
        #         * DisplayName [String] - Display name of object owner
        #         * ID [String] - Id of object owner
        #       * AccessControlList [Array]:
        #         * Grant [Hash]:
        #           * Grantee [Hash]:
        #             * DisplayName [String] - Display name of grantee
        #             * ID [String] - Id of grantee
        #             or
        #             * URI [String] - URI of group to grant access for
        #           * Permission [String] - Permission, in [FULL_CONTROL, WRITE, WRITE_ACP, READ, READ_ACP]
        #
        # @see http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTObjectGETacl.html

        def get_object_acl(bucket_name, object_name, options = {})
          unless bucket_name
            raise ArgumentError.new('bucket_name is required')
          end
          unless object_name
            raise ArgumentError.new('object_name is required')
          end
          query = {'acl' => nil}
          request({
            :expects    => 200,
            :headers    => {},
            :host       => "#{bucket_name}.#{@host}",
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::Parsers::Storage::InternetArchive::AccessControlList.new,
            :path       => CGI.escape(object_name),
            :query      => query
          })
        end
      end

      class Mock # :nodoc:all
        require 'fog/internet_archive/requests/storage/acl_utils'

        def get_object_acl(bucket_name, object_name, options = {})
          response = Excon::Response.new
          if acl = self.data[:acls][:object][bucket_name] && self.data[:acls][:object][bucket_name][object_name]
            response.status = 200
            if acl.is_a?(String)
              response.body = Fog::Storage::InternetArchive.acl_to_hash(acl)
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
