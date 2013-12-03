module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a media object.
        #
        # @param [String] id Object identifier of the media object.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @raise [Fog::Compute::VcloudDirector::Forbidden]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-Media.html
        # @since vCloud API version 0.9
        def get_media(id)
          response = request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "media/#{id}"
          )
          ensure_list! response.body, :Files, :File
          response
        end
      end

      class Mock
        def get_media(id)
          unless data[:medias][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              "No access to entity \"(com.vmware.vcloud.entity.media:#{id})\"."
            )
          end

          body = {
            :xmlns => xmlns,
            :xmlns_xsi => xmlns_xsi,
            :xsi_schemaLocation => xsi_schema_location
          }.merge(media_body(id))

          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{body[:type]};version=>#{@api_version}"},
            :body => body
          )
        end

        private

        def media_body(id)
          media = data[:medias][id]

          body = {
            :size => media[:size].to_s,
            :imageType => media[:image_type],
            :status => media[:status].to_s,
            :name => media[:name],
            :id => "urn:vcloud:media:#{id}",
            :type => 'application/vnd.vmware.vcloud.media+xml',
            :href => make_href("media/#{id}"),
            :Link => {
              :href => make_href("vdc/#{media[:vdc_id]}"),
              :type => 'application/vnd.vmware.vcloud.vdc+xml',
              :rel => 'up'
            },
            :Description => media[:description] || '',
            :Tasks => {
              # FIXME: there's only one for now
              :Task => media[:tasks].map {|task_id| task_body(task_id)}.first
            },
            :Files => {
              :File => []
            },
            :Owner => {
              :type => 'application/vnd.vmware.vcloud.owner+xml',
              :User => {
                :href => make_href("admin/user/#{user_uuid}"),
                :name => user_uuid,
                :type => 'application/vnd.vmware.admin.user+xml',
              }
            }
          }

          if media[:status] == 0
            body[:Files][:File] << {
              :size => media[:size].to_s,
              :bytesTransferred => media[:file][:bytes_transferred].to_s,
              :name => 'file',
              :Link=> {
                :href => make_href("transfer/#{media[:file][:uuid]}/file"),
                :rel => 'upload:default'
              }
            }
          end

          if api_version.to_f >= 5.1
            storage_class_id = media[:vdc_storage_class]
            body[:VdcStorageProfile] = {
              :href => make_href("vdcStorageProfile/#{storage_class_id}"),
              :name => data[:vdc_storage_classes][storage_class_id][:name],
              :type => 'application/vnd.vmware.vcloud.vdcStorageProfile+xml',
            }
          end

          body
        end
      end
    end
  end
end
