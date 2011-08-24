module Fog
  module Storage
    class AWS
      class Real

        # Create an S3 bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to create
        # * options<~Hash> - config arguments for bucket.  Defaults to {}.
        #   * 'LocationConstraint'<~Symbol> - sets the location for the bucket
        #   * 'x-amz-acl'<~String> - Permissions, must be in ['private', 'public-read', 'public-read-write', 'authenticated-read']
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * status<~Integer> - 200
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketPUT.html

        def put_bucket(bucket_name, options = {})
          if location_constraint = options.delete('LocationConstraint')
            data =
<<-DATA
  <CreateBucketConfiguration>
    <LocationConstraint>#{location_constraint}</LocationConstraint>
  </CreateBucketConfiguration>
DATA
          else
            data = nil
          end
          request({
            :expects    => 200,
            :body       => data,
            :headers    => options,
            :idempotent => true,
            :host       => "#{bucket_name}.#{@host}",
            :method     => 'PUT'
          })
        end

      end

      class Mock # :nodoc:all

        def put_bucket(bucket_name, options = {})
          acl = options['x-amz-acl'] || 'private'
          if !['private', 'public-read', 'public-read-write', 'authenticated-read'].include?(acl)
            raise Excon::Errors::BadRequest.new('invalid x-amz-acl')
          else
            self.data[:acls][:bucket][bucket_name] = self.class.acls(acl)
          end

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
            bucket['LocationConstraint'] = nil
          end
          unless self.data[:buckets][bucket_name]
            self.data[:buckets][bucket_name] = bucket
          end
          response
        end

      end
    end
  end
end
