module Fog
  module Storage
    class AWS
      class Real

        # Change lifecycle configuration for an S3 bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to set lifecycle configuration for
        # * lifecycle<~Hash>:
        #   * 'Rules'<~Array> - object expire rules
        #      * 'ID'<~String>       - Unique identifier for the rule
        #      * 'Prefix'<~String>   - Prefix identifying one or more objects to which the rule applies
        #      * 'Enabled'<~Boolean> - if rule is currently being applied
        #      * 'Days'<~Integer>    - lifetime, in days, of the objects that are subject to the rule
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketPUTlifecycle.html

        def put_bucket_lifecycle(bucket_name, lifecycle)
          builder = Nokogiri::XML::Builder.new do
            LifecycleConfiguration {
              lifecycle['Rules'].each do |rule|
                Rule {
                  ID rule['ID']
                  Prefix rule['Prefix']
                  Status rule['Enabled'] ? 'Enabled' : 'Disabled'
                  Expiration { Days rule['Days'] }
                }
              end
            }
          end

          body = builder.to_xml

          request({
                    :body     => body,
                    :expects  => 200,
                    :headers  => {'Content-MD5' => Base64.encode64(Digest::MD5.digest(body)).chomp!,
                      'Content-Type' => 'application/xml'},
                    :host     => "#{bucket_name}.#{@host}",
                    :method   => 'PUT',
                    :query    => {'lifecycle' => nil}
                  })
        end
      end
    end
  end
end
