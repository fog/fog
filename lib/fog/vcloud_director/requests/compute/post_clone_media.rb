module Fog
  module Compute
    class VcloudDirector
      class Real
        # Create a copy of a media object.
        #
        # The response includes a Task element. You can monitor the task to to
        # track the creation of the vApp template.
        #
        # @param [String] vdc_id Object identifier of the vDC.
        # @param [String] source_id Object identifier of the source media
        #   object.
        # @param [Hash] options
        # @option options [String] :Description Optional description.
        # @option options [Boolean] :IsSourceDelete A value of true deletes the
        #   Source object after successful completion of the copy operation.
        #   Defaults to false if empty or missing.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-CloneMedia.html
        # @since vCloud API version 0.9
        def post_clone_media(vdc_id, source_id, options={})
          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5'
            }
            CloneMediaParams(attrs) {
              if options.key?(:Description)
                Description options[:Description]
              end
              Source(:href => "#{end_point}media/#{source_id}")
              if options.key?(:IsSourceDelete)
                IsSourceDelete options[:IsSourceDelete]
              end
            }
          end.to_xml

          response = request(
            :body    => body,
            :expects => 201,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.cloneMediaParams+xml'},
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vdc/#{vdc_id}/action/cloneMedia"
          )
          ensure_list! response.body, :Files, :File
          response
        end
      end

      class Mock
        def post_clone_media(vdc_id, source_id, options={})
          # TODO: check this happens.
          unless source_media = data[:medias][source_id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              "No access to entity \"(com.vmware.vcloud.entity.media:#{source_id})\"."
            )
          end
          unless data[:vdcs][vdc_id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              "No access to entity \"(com.vmware.vcloud.entity.vdc:#{vdc_id})\"."
            )
          end

          media_id = uuid
          media_name = "#{source_media[:name]}-copy-#{uuid}"

          owner = {
            :href => make_href("media/#{media_id}"),
            :type => 'application/vnd.vmware.vcloud.media+xml'
          }
          task_id = enqueue_task(
            "Copy Media File #{media_name}(#{media_id})", 'vdcCopyMedia', owner,
            :on_success => lambda do
              data[:medias][media_id][:status] = 1
            end
          )

          media = source_media.dup.merge(
            :name => media_name,
            :status => 0,
            :tasks => [task_id]
          )
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
