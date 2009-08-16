unless Fog.mocking?

  module Fog
    module AWS
      class S3

        # Get configured payer for an S3 bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to get payer for
        #
        # ==== Returns
        # * response<~Fog::AWS::Response>:
        #   * body<~Hash>:
        #     * 'Payer'<~String> - Specifies who pays for download and requests
        def get_request_payment(bucket_name)
          request({
            :expects  => 200,
            :headers  => {},
            :host     => "#{bucket_name}.#{@host}",
            :method   => 'GET',
            :parser   => Fog::Parsers::AWS::S3::GetRequestPayment.new,
            :query    => 'requestPayment'
          })
        end

      end
    end
  end

else

  module Fog
    module AWS
      class S3

        def get_request_payment(bucket_name)
          response = Fog::Response.new
          if bucket = @data[:buckets][bucket_name]
            response.status = 200
            response.body = { 'Payer' => bucket['Payer'] }
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
