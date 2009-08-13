unless Fog.mocking?

  module Fog
    module AWS
      class S3

        # Get location constraint for an S3 bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to get location constraint for
        #
        # ==== Returns
        # * response<~Fog::AWS::Response>:
        #   * body<~Hash>:
        #     * 'LocationConstraint'<~String> - Location constraint of the bucket
        def get_bucket_location(bucket_name)
          request({
            :expects => 200,
            :headers => {},
            :host => "#{bucket_name}.#{@host}",
            :method => 'GET',
            :parser => Fog::Parsers::AWS::S3::GetBucketLocation.new,
            :query => 'location'
          })
        end

      end
    end
  end

else

  module Fog
    module AWS
      class S3

        def get_bucket_location(bucket_name)
          response = Fog::Response.new
          bucket_status = get_bucket(bucket_name).status
          if bucket_status == 200
            response.status = 200
            bucket = @data['Buckets'].select {|bucket| bucket['Name'] == bucket_name}.first
            response.body = {'LocationConstraint' => bucket['LocationConstraint'] }
          else
            response.status = bucket_status
          end
          response
        end

      end
    end
  end

end