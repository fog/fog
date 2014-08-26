module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds S3
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addS3.html]
        def add_s3(bucket, accesskey, secretkey, options={})
          options.merge!(
            'command' => 'addS3', 
            'bucket' => bucket, 
            'accesskey' => accesskey, 
            'secretkey' => secretkey  
          )
          request(options)
        end
      end

    end
  end
end

