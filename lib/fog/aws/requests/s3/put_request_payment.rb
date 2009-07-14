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
          :body => data,
          :headers => {},
          :host => "#{bucket_name}.#{@host}",
          :method => 'PUT',
          :query => "requestPayment"
        })
      end

    end
  end
end
