module Fog
  module Compute
    class VcloudDirector
      class Real
        extend Fog::Deprecation
        deprecate :get_vm_cpu, :get_cpu_rasd_item

        # Retrieve the RASD item that specifies CPU properties of a VM.
        #
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-CpuRasdItem.html
        # @since vCloud API version 0.9
        def get_cpu_rasd_item(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/virtualHardwareSection/cpu"
          )
        end

      end

      class Mock

        def get_cpu_rasd_item(id)
          type = 'application/vnd.vmware.vcloud.rasdItem+xml'

          unless vm = data[:vms][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end

          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{type};version=#{api_version}"},
            :body => get_cpu_rasd_item_body(id, vm)
          )
        end

        def get_cpu_rasd_item_body(id, vm)
          {
            :ns12_href => make_href("vApp/#{id}/virtualHardwareSection/cpu"),
            :ns12_type => "application/vnd.vmware.vcloud.rasdItem+xml",
            :"rasd:AllocationUnits"=>"hertz * 10^6",
            :"rasd:Description"=>"Number of Virtual CPUs",
            :"rasd:ElementName"=>"#{vm[:cpu_count]} virtual CPU(s)",
            :"rasd:InstanceID"=>"4",
            :"rasd:Reservation"=>"0",
            :"rasd:ResourceType"=>"3",
            :"rasd:VirtualQuantity"=>"#{vm[:cpu_count]}",
            :"rasd:Weight"=>"0",
          }
        end

      end

    end
  end
end
