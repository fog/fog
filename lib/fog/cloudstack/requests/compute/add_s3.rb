module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds S3
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addS3.html]
        def add_s3(options={})
          request(options)
        end


        def add_s3(accesskey, bucket, secretkey, options={})
          options.merge!(
            'command' => 'addS3', 
            'accesskey' => accesskey, 
            'bucket' => bucket, 
            'secretkey' => secretkey  
          )
          request(options)
        end
      end

    end
  end
end

