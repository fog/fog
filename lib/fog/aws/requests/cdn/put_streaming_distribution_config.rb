module Fog
  module CDN
    class AWS
      class Real

        require 'fog/aws/parsers/cdn/streaming_distribution'

        # update a streaming distribution in CloudFront
        #
        # ==== Parameters
        # * distribution_id<~String> - Id of distribution to update config for
        # * options<~Hash> - config for distribution.  Defaults to {}.
        #   REQUIRED:
        #   * 'S3Origin'<~Hash>:
        #     * 'DNSName'<~String> - origin to associate with distribution, ie 'mybucket.s3.amazonaws.com'
        #   OPTIONAL:
        #   * 'CallerReference'<~String> - Used to prevent replay, defaults to Time.now.to_i.to_s
        #   * 'Comment'<~String> - Optional comment about distribution
        #   * 'CNAME'<~Array> - Optional array of strings to set as CNAMEs
        #   * 'Enabled'<~Boolean> - Whether or not distribution should accept requests, defaults to true
        #   * 'Logging'<~Hash>: Optional logging config
        #     * 'Bucket'<~String> - Bucket to store logs in, ie 'mylogs.s3.amazonaws.com'
        #     * 'Prefix'<~String> - Optional prefix for log filenames, ie 'myprefix/'
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'DomainName'<~String>: Domain name of distribution
        #     * 'Id'<~String> - Id of distribution
        #     * 'LastModifiedTime'<~String> - Timestamp of last modification of distribution
        #     * 'Status'<~String> - Status of distribution
        #     * 'StreamingDistributionConfig'<~Array>:
        #       * 'CallerReference'<~String> - Used to prevent replay, defaults to Time.now.to_i.to_s
        #       * 'CNAME'<~Array> - array of associated cnames
        #       * 'Comment'<~String> - comment associated with distribution
        #       * 'Enabled'<~Boolean> - whether or not distribution is enabled
        #       * 'Logging'<~Hash>:
        #         * 'Bucket'<~String> - bucket logs are stored in
        #         * 'Prefix'<~String> - prefix logs are stored with
        #       * 'Origin'<~String> - s3 origin bucket
        #       * 'TrustedSigners'<~Array> - trusted signers
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonCloudFront/latest/APIReference/PutStreamingDistribution.html

        def put_streaming_distribution_config(distribution_id, etag, options = {})
          data = '<?xml version="1.0" encoding="UTF-8"?>'
          data << "<StreamingDistributionConfig xmlns=\"http://cloudfront.amazonaws.com/doc/#{@version}/\">"
          for key, value in options
            case value
            when Array
              for item in value
                data << "<#{key}>#{item}</#{key}>"
              end
            when Hash
              data << "<#{key}>"
              for inner_key, inner_value in value
                data << "<#{inner_key}>#{inner_value}</#{inner_key}>"
              end
              data << "</#{key}>"
            else
              data << "<#{key}>#{value}</#{key}>"
            end
          end
          data << "</StreamingDistributionConfig>"
          request({
            :body       => data,
            :expects    => 200,
            :headers    => {
              'Content-Type'  => 'text/xml',
              'If-Match'      => etag
            },
            :idempotent => true,
            :method     => 'PUT',
            :parser     => Fog::Parsers::CDN::AWS::StreamingDistribution.new,
            :path       => "/streaming-distribution/#{distribution_id}/config"
          })
        end

      end
    end
  end
end
