unless Fog.mocking?

  module Fog
    module AWS
      class S3

        # Delete an S3 bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to delete
        #
        # ==== Returns
        # * response<~Fog::AWS::Response>:
        #   * status<~Integer> - 204
        def delete_bucket(bucket_name)
          request({
            :expects  => 204,
            :headers  => {},
            :host     => "#{bucket_name}.#{@host}",
            :method   => 'DELETE'
          })
        end

      end
    end
  end

else

  module Fog
    module AWS
      class S3

        def delete_bucket(bucket_name)
          response = Fog::Response.new
          if @data[:buckets].delete(bucket_name)
            response.status = 204
          else
            response.status = 404
          end
          response
        end

      end
    end
  end

end
