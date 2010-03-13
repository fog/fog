module Fog
  module AWS
    module S3
      class Real

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

      class Mock

        def put_request_payment(bucket_name, payer)
          response = Excon::Response.new
          if bucket = @data[:buckets][bucket_name]
            response.status = 200
            bucket['Payer'] = payer
          else
            response.status = 404
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
          response
        end

      end
    end
  end
end
