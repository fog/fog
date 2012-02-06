module Fog
  module Storage
    class AWS
      class Real

        require 'fog/aws/parsers/storage/get_bucket_versioning'

        # Get versioning status for an S3 bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to get versioning status for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'VersioningConfiguration'<~Hash>
        #         * Status<~String>: Versioning status in ['Enabled', 'Suspended', nil]
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketGETversioningStatus.html

        def get_bucket_versioning(bucket_name)
          unless bucket_name
            raise ArgumentError.new('bucket_name is required')
          end
          request({
            :expects    => 200,
            :headers    => {},
            :host       => "#{bucket_name}.#{@host}",
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::Parsers::Storage::AWS::GetBucketVersioning.new,
            :query      => {'versioning' => nil}
          })
        end
      end

      class Mock
        def get_bucket_versioning(bucket_name)
          response = Excon::Response.new
          bucket = self.data[:buckets][bucket_name]

          if bucket
            response.status = 200

            if bucket[:versioning]
              response.body = { 'VersioningConfiguration' => { 'Status' => bucket[:versioning] } }
            else
              response.body = { 'VersioningConfiguration' => {} }
            end

          else
            response.status = 404
            response.body = {
              'Error' => {
                'Code' => 'NoSuchBucket',
                'Message' => 'The specified bucket does not exist',
                'BucketName' => bucket_name,
                'RequestId' => Fog::Mock.random_hex(16),
                'HostId' => Fog::Mock.random_base64(65)
              }
            }

            raise(Excon::Errors.status_error({:expects => 200}, response))
          end

          response
        end
      end
    end
  end
end
