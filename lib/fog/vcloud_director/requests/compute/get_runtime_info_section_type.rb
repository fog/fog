module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve the runtime info section of a VM.
        #
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-RuntimeInfoSectionType.html
        # @since vCloud API version 1.5
        def get_runtime_info_section_type(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/runtimeInfoSection"
          )
        end
      end

      class Mock
        def get_runtime_info_section_type(id)

          type = 'application/vnd.vmware.vcloud.virtualHardwareSection+xml'

          unless vm = data[:vms][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end

          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{type};version=#{api_version}"},
            :body => get_vm_runtime_info_section_body(id, vm)
          )
        end

        def get_vm_runtime_info_section_body(id, vm)
          {
            :xmlns_ns12 => "http://www.vmware.com/vcloud/v1.5",
            :ns12_href => make_href("vApp/#{id}/runtimeInfoSection"),
            :ns12_type => "application/vnd.vmware.vcloud.virtualHardwareSection+xml",
            :"ovf:Info" => "Specifies Runtime info",
            :VMWareTools => {
              :version => "9282",
            }
          }
        end

      end
    end
  end
end
