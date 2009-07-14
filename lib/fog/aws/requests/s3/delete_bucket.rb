module Fog
  module AWS
    class S3

      # Delete an S3 bucket
      #
      # ==== Parameters
      # * bucket_name<~String> - name of bucket to delete
      #
      # ==== Returns
      # FIXME: docs
      def delete_bucket(bucket_name)
        request({
          :headers => {},
          :host => "#{bucket_name}.#{@host}",
          :method => 'DELETE'
        })
      end

    end
  end
end
