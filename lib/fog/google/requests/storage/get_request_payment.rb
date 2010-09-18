module Fog
  module Google
    class Storage
      class Real

        require 'fog/google/parsers/storage/get_request_payment'

        # Get configured payer for an S3 bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to get payer for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'Payer'<~String> - Specifies who pays for download and requests
        def get_request_payment(bucket_name)
          request({
            :expects  => 200,
            :headers  => {},
            :host     => "#{bucket_name}.#{@host}",
            :idempotent => true,
            :method   => 'GET',
            :parser   => Fog::Parsers::Google::Storage::GetRequestPayment.new,
            :query    => {'requestPayment' => nil}
          })
        end

      end

      class Mock

        def get_request_payment(bucket_name)
          response = Excon::Response.new
          if bucket = @data[:buckets][bucket_name]
            response.status = 200
            response.body = { 'Payer' => bucket['Payer'] }
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
