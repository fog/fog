module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds S3
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addS3.html]
        def add_s3(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addS3') 
          else
            options.merge!('command' => 'addS3', 
            'accesskey' => args[0], 
            'bucket' => args[1], 
            'secretkey' => args[2])
          end
          request(options)
        end
      end

    end
  end
end

