module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/generators/compute/media.rb'

        # Upload a media image.
        #
        # The response includes an upload link for the media image.
        #
        # @param [String] vdc_id Object identifier of the vDC.
        # @param [String] name The name of the media image.
        # @param [String] image_type Media image type. One of: iso, floppy.
        # @param [Integer] size Size of the media file, in bytes.
        # @param [Hash] options
        # @option options [String] :Description Optional description.
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-UploadMedia.html
        #   vCloud API Documentation
        # @since vCloud API version 0.9
        def post_upload_media(vdc_id, name, image_type, size, options={})
          body = Fog::Generators::Compute::VcloudDirector::Media.new(name, image_type, size, options)

          request(
            :body    => body.to_xml,
            :expects => 201,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.media+xml'},
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vdc/#{vdc_id}/media"
          )
        end
      end

      class Mock
        def post_upload_media(vdc_id, name, image_type, size, options={})
          response = Excon::Response.new

          unless valid_uuid?(vdc_id)
            response.status = 400
            raise Excon::Errors.status_error({:expects => 201}, response)
          end
          unless ['iso','floppy'].include?(image_type)
            response.status = 400
            raise Excon::Errors.status_error({:expects => 201}, response)
          end
          unless size =~ /^\d+$/
            response.status = 400
            raise Excon::Errors.status_error({:expects => 201}, response)
          end
          unless data[:vdcs].has_key?(vdc_id)
            response.status = 403
            raise Excon::Errors.status_error({:expects => 201}, response)
          end

          Fog::Mock.not_implemented
        end
      end
    end
  end
end
