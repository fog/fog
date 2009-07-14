module Fog
  module AWS
    class S3

      # Create an S3 bucket
      #
      # ==== Parameters
      # * bucket_name<~String> - name of bucket to create
      # * options<~Hash> - config arguments for bucket.  Defaults to {}.
      #   * :location_constraint<~Symbol> - sets the location for the bucket
      def put_bucket(bucket_name, options = {})
        if options[:location_constraint]
          data =
<<-DATA
  <CreateBucketConfiguration>
    <LocationConstraint>#{options[:location_constraint]}</LocationConstraint>
  </CreateBucketConfiguration>
DATA
        else
          data = nil
        end
        request({
          :body => data,
          :headers => {},
          :host => "#{bucket_name}.#{@host}",
          :method => 'PUT'
        })
      end

    end
  end
end
