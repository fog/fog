module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve the operating system section of a VM.
        #
        # @param [String] id The object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-OperatingSystemSection.html
        # @since vCloud API version 0.9
        def get_operating_system_section(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/operatingSystemSection/"
          )
        end
      end

      class Mock

        def get_operating_system_section(id)

          type = 'application/vnd.vmware.vcloud.operatingSystemSection+xml'

          unless vm = data[:vms][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end

          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{type};version=#{api_version}"},
            :body => get_vm_operating_system_section_body(id, vm)
          )

        end

        def get_vm_operating_system_section_body(id, vm)
          {
            :xmlns_ns12=>"http://www.vmware.com/vcloud/v1.5",
            :ovf_id => "94", # TODO: What is this?
            :ns12_href => make_href("vApp/#{id}/operatingSystemSection/"),
            :ns12_type => "application/vnd.vmware.vcloud.operatingSystemSection+xml",
            :vmw_osType => vm[:guest_os_type], # eg "ubuntu64Guest"
            :"ovf:Info"=>"Specifies the operating system installed",
            :"ovf:Description"=> vm[:guest_os_description], # eg "Ubuntu Linux (64-bit)",
          }
        end

      end
    end
  end
end
