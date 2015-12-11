module Fog
  module Compute
    class VcloudDirector
      class Real
        
        # Updates VM configuration.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the VM.
        # @param [Hash] options
        #
        # @option options [String] :name Change the VM's name [required].
        # @option options [String] :description VM description
        # @option options [Integer] :cpu Number of CPUs
        # @option options [Integer] :memory Memory in MB
        #
        # @return [Excon::Response]
        #   * body<~Hash>:
        #     * :Tasks<~Hash>:
        #       * :Task<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-ReconfigureVm.html
        # @since vCloud API version 5.1
        def post_reconfigure_vm(id, options={})
          
          body = Nokogiri::XML::Builder.new do |xml|
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5',
              'xmlns:ovf' => 'http://schemas.dmtf.org/ovf/envelope/1',
              'xmlns:rasd' => 'http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData',
              :name => options[:name]
            }
            xml.Vm(attrs) do
              xml.Description options[:description] if options[:description]
              virtual_hardware_section(xml, options)
            end
          end.to_xml
          
          request(
            :body    => body,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.vm+xml'},
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/action/reconfigureVm"
          )
        end
        
        private
        
        def virtual_hardware_section(xml, options)
          return unless options[:cpu] or options[:memory]
          xml['ovf'].VirtualHardwareSection do
            xml['ovf'].Info 'Virtual Hardware Requirements'
            cpu_section(xml, options[:cpu]) if options[:cpu]
            memory_section(xml, options[:memory]) if options[:memory]
          end
        end
        
        def cpu_section(xml, cpu)
          xml['ovf'].Item do
            xml['rasd'].AllocationUnits 'hertz * 10 ^ 6'
            xml['rasd'].InstanceID 5
            xml['rasd'].ResourceType 3
            xml['rasd'].VirtualQuantity cpu.to_i
          end
        end
        
        def memory_section(xml, memory)
          xml['ovf'].Item do
            xml['rasd'].AllocationUnits 'byte * 2^20'
            xml['rasd'].InstanceID 6
            xml['rasd'].ResourceType 4
            xml['rasd'].VirtualQuantity memory.to_i
          end
        end
        
      end
      
      class Mock
        def post_reconfigure_vm(id, options={})
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
              data[:vms][id][:name] = options[:name]
              data[:vms][id][:description] = options[:description] if options[:description]
              data[:vms][id][:cpu_count] = options[:cpu] if options[:cpu]
              data[:vms][id][:memory_in_mb] = options[:memory] if options[:memory]
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
