module Fog
  module Compute
    class VcloudDirector
      class Real
        extend Fog::Deprecation
        deprecate :put_vm_memory, :put_memory

        # Update the RASD item that specifies memory properties of a VM.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the VM.
        # @param [Integer] memory Memory size in Megabytes.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/PUT-Memory.html
        # @since vCloud API version 0.9
        def put_memory(id, memory)
          data = <<EOF
          <Item 
            xmlns="http://www.vmware.com/vcloud/v1.5" 
            xmlns:rasd="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData" 
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
            xmlns:ns12="http://www.vmware.com/vcloud/v1.5" 
            ns12:href="#{end_point}vApp/#{id}/virtualHardwareSection/memory" 
            ns12:type="application/vnd.vmware.vcloud.rasdItem+xml" 
            xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 #{end_point}v1.5/schema/master.xsd http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2.22.0/CIM_ResourceAllocationSettingData.xsd">
            <rasd:AllocationUnits>byte * 2^20</rasd:AllocationUnits>
            <rasd:Description>Memory Size</rasd:Description>
            <rasd:ElementName>#{memory} MB of memory</rasd:ElementName>
            <rasd:InstanceID>5</rasd:InstanceID>
            <rasd:Reservation>0</rasd:Reservation>
            <rasd:ResourceType>4</rasd:ResourceType>
            <rasd:VirtualQuantity>#{memory}</rasd:VirtualQuantity>
            <rasd:Weight>0</rasd:Weight>
            <Link rel="edit" type="application/vnd.vmware.vcloud.rasdItem+xml" href="#{end_point}vApp/#{id}/virtualHardwareSection/memory"/>
          </Item>
EOF

          request(
            :body    => data,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.rasdItem+xml'},
            :method  => 'PUT',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/virtualHardwareSection/memory"
          )
        end
      end

      class Mock

        def put_memory(id, memory)
          unless vm = data[:vms][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end

          owner = {
            :href => make_href("vApp/#{id}"),
            :type => 'application/vnd.vmware.vcloud.vm+xml'
          }
          task_id = enqueue_task(
            "Updating Virtual Machine #{data[:vms][id][:name]}(#{id})", 'vappUpdateVm', owner,
            :on_success => lambda do
              data[:vms][id][:memory_in_mb] = memory
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
