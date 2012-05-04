module Fog
  module Compute
    class Cloudstack
      class Real

        # Extracts a template
        #
        # ==== Parameters
        # * id<~Integer>: The ID of the template
        # * mode<~String>: The mode of extraction - HTTP_DOWNLOAD or FTP_UPLOAD
        # * zoneId<~Integer>: The ID of the zone where the ISO is originally located
        # * options<~Hash>: A hash of optional parameters, see the documentation below for details
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/extractTemplate.html]
        def extract_template(id, mode, zoneId, options={})
          options.merge!(
            'command' => 'extractTemplate',
            'id'      => id,
            'mode'    => mode,
            'zoneId'  => zoneId
          )

          request(options)
        end
      end

      class Mock

        def extract_template(id, mode, zoneId, options={})
          {"extracttemplateresponse"=>{"jobid"=>158}}
        end
      end
    end
  end
end