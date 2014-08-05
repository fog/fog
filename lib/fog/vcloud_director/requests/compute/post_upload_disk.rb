module Fog
  module Compute
    class VcloudDirector
      class Real
        # Create a disk.
        #
        # @param [String] id Object identifier of the vDC.
        # @param [String] name The name of the disk.
        # @param [Integer] size Size of the disk. For modify operation this is
        #   required only for the XSD validation it could not be changed.
        # @param [Hash] options
        # @option options [String] :operationKey Optional unique identifier to
        #   support idempotent semantics for create and delete operations.
        # @option options [Integer] :busSubType Disk bus sub type.
        # @option options [Integer] :busType Disk bus type.
        # @option options [String] :Description Optional description.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #     * :href<~String> - The URI of the disk.
        #     * :type<~String> - The MIME type of the disk.
        #     * :id<~String> - The disk identifier, expressed in URN format.
        #     * :operationKey<~String> - Optional unique identifier to support
        #       idempotent semantics for create and delete operations.
        #     * :name<~String> - The name of the disk.
        #     * :status<~String> - Creation status of the disk.
        #     * :busSubType<~String> - Disk bus sub type.
        #     * :busType<~String> - Disk bus type.
        #     * :size<~String> - Size of the disk.
        #     * :Link:
        #     * :Description<~String> - Optional description.
        #     * :Tasks<~Hash>:
        #     * :StorageProfile<~Hash> - Storage profile of the disk.
        #       * :href<~String> - Contains the URI to the entity.
        #       * :name<~String> - Contains the name of the entity.
        #       * :type<~String> - Contains the type of the entity.
        #     * :Owner<~Hash> - Disk owner.
        #       * :type<~String> - The MIME type of the entity.
        #       * :User<~Hash> - Reference to the user who is the owner of this
        #         disk.
        #         * :href<~String> - Contains the URI to the entity.
        #         * :name<~String> - Contains the name of the entity.
        #         * :type<~String> - Contains the type of the entity.
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-CreateDisk.html
        # @since vCloud API version 5.1
        def post_upload_disk(id, name, size, options={})
          body = Nokogiri::XML::Builder.new do
            DiskCreateParams(:xmlns => 'http://www.vmware.com/vcloud/v1.5') {
              attrs = {
                :name => name,
                :size => size
              }
              attrs[:operationKey] = options[:operationKey] if options.key?(:operationKey)
              attrs[:busSubType] = options[:busSubType] if options.key?(:busSubType)
              attrs[:busType] = options[:busType] if options.key?(:busType)
              Disk(attrs) {
                if options.key?(:Description)
                  Description options[:Description]
                end
                if options.key?(:StorageProfile)
                  attrs = {
                    :href => options[:StorageProfile][:href]
                  }
                  StorageProfile(attrs)
                end
              }
            }
          end.to_xml

          request(
            :body    => body,
            :expects => 201,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.diskCreateParams+xml'},
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vdc/#{id}/disk"
          )
        end
      end

      class Mock
        def post_upload_disk(id, name, size, options={})
          unless size.to_s =~ /^\d+$/
            raise Fog::Compute::VcloudDirector::BadRequest.new(
              "validation error on field 'diskSpec.sizeBytes': must be greater than or equal to 0"
            )
          end
          unless data[:vdcs][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'No access to entity "(com.vmware.vcloud.entity.vdc:%s)".' % id
            )
          end

          disk_id = uuid

          owner = {
            :href => make_href("disk/#{disk_id}"),
            :type => 'application/vnd.vmware.vcloud.disk+xml'
          }
          task_id = enqueue_task(
            "Creating Disk #{name}(#{disk_id})", 'vdcCreateDisk', owner,
            :on_success => lambda do
              data[:disks][disk_id][:status] = 1
            end
          )

          disk = {
            :description => options[:Description],
            :name => name,
            :size => size.to_i,
            :status => 0,
            :tasks => [task_id],
            :vdc_id => id,
            :vdc_storage_class => data[:vdc_storage_classes].find {|k,v| v[:default]}.first
          }
          data[:disks][disk_id] = disk

          body = {
            :xmlns => xmlns,
            :xmlns_xsi => xmlns_xsi,
            :xsi_schemaLocation => xsi_schema_location
          }.merge(disk_body(disk_id))

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
