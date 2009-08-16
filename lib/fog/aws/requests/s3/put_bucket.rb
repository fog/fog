unless Fog.mocking?

  module Fog
    module AWS
      class S3

        # Create an S3 bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to create
        # * options<~Hash> - config arguments for bucket.  Defaults to {}.
        #   * :location_constraint<~Symbol> - sets the location for the bucket
        #
        # ==== Returns
        # * response<~Fog::AWS::Response>:
        #   * status<~Integer> - 200
        def put_bucket(bucket_name, options = {})
          if options['LocationConstraint']
            data =
  <<-DATA
    <CreateBucketConfiguration>
      <LocationConstraint>#{options['LocationConstraint']}</LocationConstraint>
    </CreateBucketConfiguration>
  DATA
          else
            data = nil
          end
          request({
            :expects  => 200,
            :body     => data,
            :headers  => {},
            :host     => "#{bucket_name}.#{@host}",
            :method   => 'PUT'
          })
        end

      end
    end
  end

else

  module Fog
    module AWS
      class S3

        def put_bucket(bucket_name, options = {})
          response = Fog::Response.new
          response.status = 200
          bucket = {
            'Name' => bucket_name,
            'Contents' => [],
            'CreationDate' => Time.now,
            'Payer' => 'BucketOwner'
          }
          if options['LocationConstraint']
            bucket['LocationConstraint'] = options['LocationConstraint']
          else
            bucket['LocationConstraint'] = ''
          end
          @data['Buckets'] << bucket
          response
        end

      end
    end
  end

end