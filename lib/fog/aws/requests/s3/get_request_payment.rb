module Fog
  module AWS
    class S3

      # Get configured payer for an S3 bucket
      #
      # ==== Parameters
      # * bucket_name<~String> - name of bucket to get payer for
      #
      # ==== Returns
      # FIXME: docs
      def get_request_payment(bucket_name)
        request({
          :headers => {},
          :host => "#{bucket_name}.#{@host}",
          :method => 'GET',
          :parser => Fog::Parsers::AWS::S3::GetRequestPayment.new,
          :query => 'requestPayment'
        })
      end

    end
  end
end
