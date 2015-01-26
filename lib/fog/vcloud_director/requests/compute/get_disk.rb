module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a disk.
        #
        # @param [String] id Object identifier of the disk.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #     * :href<~String> - The URI of the disk.
        #     * :type<~String> - The MIME type of the disk.
        #     * :id<~String> - The disk identifier, expressed in URN format.
        #     * :name<~String> - The name of the disk.
        #     * :status<~String> - Creation status of the disk.
        #     * :busSubType<~String> - Disk bus sub type.
        #     * :busType<~String> - Disk bus type.
        #     * :size<~String> - Size of the disk.
        #     * :Description<~String> - Optional description.
        #     * :Tasks<~Hash> - A list of queued, running, or recently
        #       completed tasks associated with this disk.
        #     * :StorageProfile<~Hash> - Storage profile of the disk.
        #     * :Owner<~Hash> - Disk owner.
        #
        # @raise [Fog::Compute::VcloudDirector::Forbidden]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-Disk.html
        # @since vCloud API version 5.1
        def get_disk(id)
          response = request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "disk/#{id}"
          )
          ensure_list! response.body, :Link
          ensure_list! response.body, :Tasks, :Task
          ensure_list! response.body, :Files, :File
          response
        end
      end

      class Mock
        def get_disk(id)
          unless data[:disks][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'No access to entity "com.vmware.vcloud.entity.disk:%s".' % id
            )
          end

          body = {
            :xmlns => xmlns,
            :xmlns_xsi => xmlns_xsi,
            :xsi_schemaLocation => xsi_schema_location
          }.merge(disk_body(id))

          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{body[:type]};version=#{@version}"},
            :body => body
          )
        end

        private

        def disk_body(id)
          disk = data[:disks][id]
          storage_class_id = disk[:vdc_storage_class]

          body = {
            :href => make_href("disk/#{id}"),
            :type => 'application/vnd.vmware.vcloud.disk+xml',
            :id => "urn:vcloud:disk:#{id}",
            :name => disk[:name],
            :status => disk[:status].to_s,
            :busSubType => disk[:bus_sub_type],
            :busType => disk[:bus_type],
            :size => disk[:size].to_s,
            :Link => [
              {
                :href => make_href("vdc/#{disk[:vdc_id]}"),
                :rel => 'up',
                :type => 'application/vnd.vmware.vcloud.vdc+xml'
              }
            ],
            :Description => disk[:description],
            :Tasks => {
              # FIXME: there's only one for now
              :Task => disk[:tasks].map {|task_id| task_body(task_id)}.first
            },
            :Files => {
              :File => []
            },
            :StorageProfile => {
              :href => make_href("vdcStorageProfile/#{storage_class_id}"),
              :name => data[:vdc_storage_classes][storage_class_id][:name],
              :type => 'application/vnd.vmware.vcloud.vdcStorageProfile+xml',
            },
            :Owner => {
              :type => 'application/vnd.vmware.vcloud.owner+xml',
              :User => {
                :href => make_href("admin/user/#{user_uuid}"),
                :name => user_name,
                :type => 'application/vnd.vmware.admin.user+xml',
              }
            }
          }

          if api_version.to_f >= 5.1
            storage_class_id = disk[:vdc_storage_class]
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
