module Fog
  module AWS
    class S3
      class Real

        # Create an S3 bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to create
        # * options<~Hash> - config arguments for bucket.  Defaults to {}.
        #   * :location_constraint<~Symbol> - sets the location for the bucket
        #
        # ==== Returns
        # * response<~Excon::Response>:
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
            :expects    => 200,
            :body       => data,
            :headers    => {},
            :idempotent => true,
            :host       => "#{bucket_name}.#{@host}",
            :method     => 'PUT'
          })
        end

      end

      class Mock

        def put_bucket(bucket_name, options = {})
          response = Excon::Response.new
          response.status = 200
          bucket = {
            :objects        => {},
            'Name'          => bucket_name,
            'CreationDate'  => Time.now,
            'Owner'         => { 'DisplayName' => 'owner', 'ID' => 'some_id'},
            'Payer'         => 'BucketOwner'
          }
          if options['LocationConstraint']
            bucket['LocationConstraint'] = options['LocationConstraint']
          else
            bucket['LocationConstraint'] = ''
          end
          unless @data[:buckets][bucket_name]
            @data[:buckets][bucket_name] = bucket
          end
          response
        end

      end
    end
  end
end
