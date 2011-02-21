module Fog
  module AWS
    class Storage
      class Real

        # Change website configuration for an S3 bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to modify
        # * suffix<~String> - suffix to append to requests for the bucket
        # * options<~Hash>
        #   * key<~String> - key to use for 4XX class errors
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketPUTwebsite.html

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
    end
  end
end
