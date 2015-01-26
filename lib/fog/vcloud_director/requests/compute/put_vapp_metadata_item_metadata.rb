module Fog
  module Compute
    class VcloudDirector
      class Real
        # Set the value for the specified metadata key to the value provided,
        # overwriting any existing value.
        #
        # @param [String] id Object identifier of the vApp or VM.
        # @param [String] key Key of the metadata item.
        # @param [Boolean,DateTime,Fixnum,String] value Value of the metadata
        #   item.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/PUT-VAppMetadataItem-metadata.html
        # @since vCloud API version 1.5
        def put_vapp_metadata_item_metadata(id, key, value)
          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            }
            MetadataValue(attrs) {
              if api_version.to_f < 5.1
                Value value
              else
                type = case value
                       when TrueClass, FalseClass then 'MetadataBooleanValue';
                       when DateTime then 'MetadataDateTimeValue';
                       when Fixnum then 'MetadataNumberValue';
                       else 'MetadataStringValue'
                       end
                TypedValue('xsi:type' => type) { Value value }
              end
            }
          end.to_xml

          request(
            :body    => body,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.metadata.value+xml'},
            :method  => 'PUT',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/metadata/#{URI.escape(key)}"
          )
        end
      end

      class Mock

        def put_vapp_metadata_item_metadata(id, key, value)
          unless vm_or_vapp = data[:vapps][id] || vm_or_vapp = data[:vms][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end

          owner = {
            :href => make_href("vApp/#{id}"),
            :type => 'application/vnd.vmware.vcloud.vm+xml'
          }
          task_id = enqueue_task(
            "Updating Virtual Machine #{vm_or_vapp[:name]}(#{id})", 'vappUpdateVm', owner,
            :on_success => lambda do
              vm_or_vapp[:metadata][key] = value
            end
          )
          body = {
            :xmlns => xmlns,
            :xmlns_xsi => xmlns_xsi,
            :xsi_schemaLocation => xsi_schema_location,
          }.merge(task_body(task_id))

          Excon::Response.new(
            :status => 202,
            :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
            :body => body
          )

        end

      end
    end
  end
end
