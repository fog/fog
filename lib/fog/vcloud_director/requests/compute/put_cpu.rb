module Fog
  module Compute
    class VcloudDirector
      class Real
        extend Fog::Deprecation
        deprecate :put_vm_cpu, :put_cpu

        # Update the RASD item that specifies CPU properties of a VM.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the VM.
        # @param [Integer] num_cpus
        # @return [Excon:Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/PUT-Cpu.html
        # @since vCloud API version 0.9
        def put_cpu(id, num_cpus)
          data = <<EOF
          <Item 
            xmlns="http://www.vmware.com/vcloud/v1.5" 
            xmlns:rasd="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData" 
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
            xmlns:ns12="http://www.vmware.com/vcloud/v1.5" 
            ns12:href="#{end_point}vApp/#{id}/virtualHardwareSection/cpu" 
            ns12:type="application/vnd.vmware.vcloud.rasdItem+xml" 
            xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 #{end_point}v1.5/schema/master.xsd http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2.22.0/CIM_ResourceAllocationSettingData.xsd">
            <rasd:AllocationUnits>hertz * 10^6</rasd:AllocationUnits>
            <rasd:Description>Number of Virtual CPUs</rasd:Description>
            <rasd:ElementName>#{num_cpus} virtual CPU(s)</rasd:ElementName>
            <rasd:InstanceID>4</rasd:InstanceID>
            <rasd:Reservation>0</rasd:Reservation>
            <rasd:ResourceType>3</rasd:ResourceType>
            <rasd:VirtualQuantity>#{num_cpus}</rasd:VirtualQuantity>
            <rasd:Weight>0</rasd:Weight>
            <Link rel="edit" type="application/vnd.vmware.vcloud.rasdItem+xml" href="#{end_point}vApp/#{id}/virtualHardwareSection/cpu"/>
          </Item>
EOF

          request(
            :body    => data,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.rasdItem+xml'},
            :method  => 'PUT',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/virtualHardwareSection/cpu"
          )
        end
      end

      class Mock

        def put_cpu(id, num_cpus)
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
              data[:vms][id][:cpu_count] = num_cpus
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
