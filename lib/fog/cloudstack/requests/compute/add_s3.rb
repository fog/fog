module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds S3
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addS3.html]
        def add_s3(options={})
          options.merge!(
            'command' => 'addS3', 
            'bucket' => options['bucket'], 
            'accesskey' => options['accesskey'], 
            'secretkey' => options['secretkey']  
          )
          request(options)
        end
      end

    end
  end
end

