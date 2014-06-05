module Fog
  module Storage
    class AWS
      class Real
        # Change lifecycle configuration for an S3 bucket
        #
        # @param bucket_name [String] name of bucket to set lifecycle configuration for
        # * lifecycle [Hash]:
        #   * Rules [Array] object expire rules
        #     * ID [String] Unique identifier for the rule
        #     * Prefix [String] Prefix identifying one or more objects to which the rule applies
        #     * Enabled [Boolean] if rule is currently being applied
        #     * Expiration [Hash] Container for the object expiration rule.
        #       * Days [Integer] lifetime, in days, of the objects that are subject to the rule
        #       * Date [Date] Indicates when the specific rule take effect.
        #         The date value must conform to the ISO 8601 format. The time is always midnight UTC.
        #     * Transition [Hash] Container for the transition rule that describes when objects transition
        #       to the Glacier storage class
        #       * Days [Integer] lifetime, in days, of the objects that are subject to the rule
        #       * Date [Date] Indicates when the specific rule take effect.
        #         The date value must conform to the ISO 8601 format. The time is always midnight UTC.
        #       * StorageClass [String] Indicates the Amazon S3 storage class to which you want the object
        #         to transition to.
        #
        #
        # @see http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketPUTlifecycle.html
        #
        def put_bucket_lifecycle(bucket_name, lifecycle)
          builder = Nokogiri::XML::Builder.new do
            LifecycleConfiguration {
              lifecycle['Rules'].each do |rule|
                Rule {
                  ID rule['ID']
                  Prefix rule['Prefix']
                  Status rule['Enabled'] ? 'Enabled' : 'Disabled'
                  unless (rule['Expiration'] or rule['Transition'])
                    Expiration { Days rule['Days'] }
                  else
                    if rule['Expiration']
                      if rule['Expiration']['Days']
                        Expiration { Days rule['Expiration']['Days'] }
                      elsif rule['Expiration']['Date']
                        Expiration { Date rule['Expiration']['Date'].is_a?(Time) ? rule['Expiration']['Date'].utc.iso8601 : Time.parse(rule['Expiration']['Date']).utc.iso8601 }
                      end
                    end
                    if rule['Transition']
                      Transition {
                        if rule['Transition']['Days']
                          Days rule['Transition']['Days']
                        elsif rule['Transition']['Date']
                          Date rule['Transition']['Date'].is_a?(Time) ? time.utc.iso8601 : Time.parse(time).utc.iso8601
                        end
                        StorageClass rule['Transition']['StorageClass'].nil? ? 'GLACIER' : rule['Transition']['StorageClass']
                      }
                    end
                  end
                }
              end
            }
          end
          body = builder.to_xml
          body.gsub! /<([^<>]+)\/>/, '<\1></\1>'
          request({
                    :body     => body,
                    :expects  => 200,
                    :headers  => {'Content-MD5' => Base64.encode64(Digest::MD5.digest(body)).chomp!,
                      'Content-Type' => 'application/xml'},
                    :bucket_name => bucket_name,
                    :method   => 'PUT',
                    :query    => {'lifecycle' => nil}
                  })
        end
      end
    end
  end
end
