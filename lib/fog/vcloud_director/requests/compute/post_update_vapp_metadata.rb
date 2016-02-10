module Fog
  module Compute
    class VcloudDirector
      class Real
        # Merge the metadata provided in the request with existing metadata.
        #
        # @param [String] id Object identifier of the vApp or VM.
        # @param [Hash{String=>Boolean,DateTime,Fixnum,String}] metadata
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-UpdateVAppMetadata.html
        # @since vCloud API version 1.5
        def post_update_vapp_metadata(id, metadata={})
          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            }
            Metadata(attrs) {
              metadata.each do |key, value|
                MetadataEntry {
                  Key key
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
              end
            }
          end.to_xml

          request(
            :body    => body,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.metadata+xml'},
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/metadata/"
          )
        end
      end
      class Mock
        def post_update_vapp_metadata(id, metadata={})
          unless vm = data[:vms][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end
          
          owner = {
            :href => make_href("vApp/#{id}"),
            :type => 'application/vnd.vmware.vcloud.vApp+xml'
          }
          task_id = enqueue_task(
            "Updating Virtual Machine #{data[:vms][id][:name]}(#{id})", 'vappUpdateVm', owner,
            :on_success => lambda do
              metadata.each do |k,v|
                data[:tags][id] ||= {}
                data[:tags][id][k] = v
              end
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
