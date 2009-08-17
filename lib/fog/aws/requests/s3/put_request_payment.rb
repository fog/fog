unless Fog.mocking?

  module Fog
    module AWS
      class S3

        # Change who pays for requests to an S3 bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to modify
        # * payer<~String> - valid values are BucketOwner or Requester
        def put_request_payment(bucket_name, payer)
          data =
<<-DATA
<RequestPaymentConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
  <Payer>#{payer}</Payer>
</RequestPaymentConfiguration>
DATA
          request({
            :body     => data,
            :expects  => 200,
            :headers  => {},
            :host     => "#{bucket_name}.#{@host}",
            :method   => 'PUT',
            :query    => "requestPayment"
          })
        end

      end
    end
  end

else

  module Fog
    module AWS
      class S3

        def put_request_payment(bucket_name, payer)
          response = Fog::Response.new
          if bucket = @data[:buckets][bucket_name]
            response.status = 200
            bucket['Payer'] = payer
          else
            response.status = 404
            raise(Fog::Errors.status_error(200, 404, response))
          end
          response
        end

      end
    end
  end


end