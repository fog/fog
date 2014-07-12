module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists S3s
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listS3s.html]
        def list_s3s(options={})
          options.merge!(
            'command' => 'listS3s'  
          )
          request(options)
        end
      end

    end
  end
end

