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
        # * response<~Excon::Response>:
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
          response = Excon::Response.new
          if Fog::AWS::S3.data[:buckets][bucket_name].nil?
            response.status = 404
            raise(Excon::Errors.status_error({:expects => 204}, response))
          elsif Fog::AWS::S3.data[:buckets][bucket_name] && !Fog::AWS::S3.data[:buckets][bucket_name][:objects].empty?
            response.status = 409
            raise(Excon::Errors.status_error({:expects => 204}, response))
          else
            Fog::AWS::S3.data[:buckets].delete(bucket_name)
            response.status = 204
          end
          response
        end

      end
    end
  end

end
