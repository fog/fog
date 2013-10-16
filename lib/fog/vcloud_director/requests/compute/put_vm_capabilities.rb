module Fog
  module Compute
    class VcloudDirector
      class Real
        # Update VM's capabilities.
        #
        # @param [String] id Object identifier of the VM.
        # @param [Hash] options
        # @option options [Boolean] :MemoryHotAddEnabled True if the virtual
        #   machine supports addition of memory while powered on.
        # @option options [Boolean] :CpuHotAddEnabled True if the virtual
        #   machine supports addition of virtual CPUs while powered on.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/PUT-VmCapabilities.html
        def put_vm_capabilities(id, options={})
          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5'
            }
            VmCapabilities(attrs) {
              if options.key?(:MemoryHotAddEnabled)
                MemoryHotAddEnabled options[:MemoryHotAddEnabled]
              end
              if options.key?(:CpuHotAddEnabled)
                MemoryHotAddEnabled options[:CpuHotAddEnabled]
              end
            }
          end.to_xml

          request(
            :body    => body,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.vmCapabilitiesSection+xml'},
            :method  => 'PUT',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/vmCapabilities"
          )
        end
      end
    end
  end
end
