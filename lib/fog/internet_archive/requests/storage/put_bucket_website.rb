module Fog
  module Storage
    class InternetArchive
      class Real
        # Change website configuration for an S3 bucket
        #
        # @param bucket_name [String] name of bucket to modify
        # @param suffix [String] suffix to append to requests for the bucket
        # @param options [Hash]
        # @option options key [String] key to use for 4XX class errors
        #
        # @see http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketPUTwebsite.html

        def put_bucket_website(bucket_name, suffix, options = {})
          data =
<<-DATA
<WebsiteConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
    <IndexDocument>
        <Suffix>#{suffix}</Suffix>
    </IndexDocument>
DATA

          if options[:key]
            data <<
<<-DATA
<ErrorDocument>
    <Key>#{options[:key]}</Key>
</ErrorDocument>
DATA
          end

          data << '</WebsiteConfiguration>'
          request({
            :body     => data,
            :expects  => 200,
            :headers  => {},
            :host     => "#{bucket_name}.#{@host}",
            :method   => 'PUT',
            :query    => {'website' => nil}
          })
        end
      end

      class Mock # :nodoc:all
        def put_bucket_website(bucket_name, suffix, options = {})
          response = Excon::Response.new
          if self.data[:buckets][bucket_name]
            response.status = 200
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
