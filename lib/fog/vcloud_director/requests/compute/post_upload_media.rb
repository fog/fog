module Fog
  module Compute
    class VcloudDirector
      class Real
        # Upload a media image.
        #
        # The response includes an upload link for the media image.
        #
        # @param [String] vdc_id Object identifier of the vDC.
        # @param [String] name The name of the media image.
        # @param [String] image_type Media image type. One of: iso, floppy.
        # @param [Integer] size Size of the media file, in bytes.
        # @param [Hash] options
        # @option options [String] :operationKey Optional unique identifier to
        #   support idempotent semantics for create and delete operations.
        # @option options [String] :Description Optional description.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @raise [Fog::Compute::VcloudDirector::BadRequest]
        # @raise [Fog::Compute::VcloudDirector::Forbidden]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-UploadMedia.html
        # @since vCloud API version 0.9
        # @todo Support vDC Storage Profiles.
        def post_upload_media(vdc_id, name, image_type, size, options={})
          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5',
              :name => name,
              :imageType => image_type,
              :size => size
            }
            attrs[:operationKey] = options[:operationKey] if options.key?(:operationKey)
            Media(attrs) {
              if options.key?(:Description)
                Description options[:Description]
              end
            }
          end.to_xml

          response = request(
            :body    => body,
            :expects => 201,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.media+xml'},
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vdc/#{vdc_id}/media"
          )
          ensure_list! response.body, :Files, :File
          response
        end
      end

      class Mock
        def post_upload_media(vdc_id, name, image_type, size, options={})
          unless ['iso','floppy'].include?(image_type)
            raise Fog::Compute::VcloudDirector::BadRequest.new(
              'The value of parameter imageType is incorrect.'
            )
          end
          unless size.to_s =~ /^\d+$/
            raise Fog::Compute::VcloudDirector::BadRequest.new(
              'validation error on field \'size\': must be greater than or equal to 0'
            )
          end
          unless data[:vdcs][vdc_id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              "No access to entity \"(com.vmware.vcloud.entity.vdc:#{vdc_id})\"."
            )
          end

          media_id = uuid
          file_id = uuid

          owner = {
            :href => make_href("media/#{media_id}"),
            :type => 'application/vnd.vmware.vcloud.media+xml'
          }
          task_id = enqueue_task(
            "Importing Media File #{name}(#{file_id})", 'vdcUploadMedia', owner,
            :on_success => lambda do
              media = data[:medias][media_id]
              media[:file][:bytes_transferred] = media[:size]
              media[:status] = 1
            end
          )

          media = {
            :description => options[:Description],
            :file => {
              :bytes_transferred => 0,
              :uuid => file_id
            },
            :image_type => image_type,
            :name => name,
            :size => size.to_i,
            :status => 0,
            :tasks => [task_id],
            :vdc_id => vdc_id,
            :vdc_storage_class => data[:vdc_storage_classes].find {|k,v| v[:default]}.first
          }
          data[:medias][media_id] = media

          body = {
            :xmlns => xmlns,
            :xmlns_xsi => xmlns_xsi,
            :xsi_schemaLocation => xsi_schema_location
          }.merge(media_body(media_id))

          Excon::Response.new(
            :status => 201,
            :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
            :body => body
          )
        end
      end
    end
  end
end
