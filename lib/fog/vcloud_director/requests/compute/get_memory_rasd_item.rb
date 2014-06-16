module Fog
  module Compute
    class VcloudDirector
      class Real
        extend Fog::Deprecation
        deprecate :get_vm_memory, :get_memory_rasd_item

        # Retrieve the RASD item that specifies memory properties of a VM.
        #
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-MemoryRasdItem.html
        # @since vCloud API version 0.9
        def get_memory_rasd_item(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/virtualHardwareSection/memory"
          )
        end
      end

      class Mock

        def get_memory_rasd_item(id)
          type = 'application/vnd.vmware.vcloud.rasdItem+xml'

          unless vm = data[:vms][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end

          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{type};version=#{api_version}"},
            :body => get_memory_rasd_item_body(id, vm)
          )
        end

        def get_memory_rasd_item_body(id, vm)
          {
            :ns12_href => make_href("vApp/#{id}/virtualHardwareSection/memory"),
            :ns12_type=>"application/vnd.vmware.vcloud.rasdItem+xml",
            :"rasd:AllocationUnits"=>"byte * 2^20",
            :"rasd:Description"=>"Memory Size",
            :"rasd:ElementName"=>"#{vm[:memory_in_mb]} MB of memory",
            :"rasd:InstanceID"=>"5",
            :"rasd:Reservation"=>"0",
            :"rasd:ResourceType"=>"4",
            :"rasd:VirtualQuantity"=>"#{vm[:memory_in_mb]}",
            :"rasd:Weight"=>"0",
          }
        end

      end

    end
  end
end
