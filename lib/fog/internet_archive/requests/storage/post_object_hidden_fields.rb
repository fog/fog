module Fog
  module Storage
    class InternetArchive
      class Real
        # Get a hash of hidden fields for form uploading to S3, in the form {:field_name => :field_value}
        # Form should look like: <form action="http://#{bucket_name}.#{Fog::InternetArchive::API_DOMAIN_NAME}/" method="post" enctype="multipart/form-data">
        # These hidden fields should then appear, followed by a field named 'file' which is either a textarea or file input.
        #
        # @param options Hash:
        # @option options acl [String] access control list, in ['private', 'public-read', 'public-read-write', 'authenticated-read', 'bucket-owner-read', 'bucket-owner-full-control']
        # @option options Cache-Control [String] same as REST header
        # @option options Content-Type [String] same as REST header
        # @option options Content-Disposition [String] same as REST header
        # @option options Content-Encoding [String] same as REST header
        # @option options Expires same as REST header
        # @option options key key for object, set to '${filename}' to use filename provided by user
        # @option options policy security policy for upload
        # @option options success_action_redirect url to redirct to upon success
        # @option options success_action_status status code to return on success, in [200, 201, 204]
        # @option options x-amz-security token devpay security token
        # @option options x-amz-meta... meta data tags
        #
        # @see http://docs.amazonwebservices.com/AmazonS3/latest/dev/HTTPPOSTForms.html
        #
        def post_object_hidden_fields(options = {})
          if options['policy']
            options['policy'] = Base64.encode64(Fog::JSON.encode(options['policy'])).gsub("\n", "")
            options['AWSAccessKeyId'] = @ia_access_key_id
            options['Signature'] = Base64.encode64(@hmac.sign(options['policy'])).gsub("\n", "")
          end
          options
        end
      end
    end
  end
end
