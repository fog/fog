module Fog
  module AWS
    class S3

      # Create an object in an S3 bucket
      # FIXME: docs
      def put_object(bucket_name, object_name, object, options = {})
        file = parse_file(object)
        request({
          :body => file[:body],
          :headers => options.merge!(file[:headers]),
          :host => "#{bucket_name}.#{@host}",
          :method => 'PUT',
          :path => object_name
        })
      end

    end
  end
end
