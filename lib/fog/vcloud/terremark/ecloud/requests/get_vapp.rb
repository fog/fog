module Fog
  class Vcloud
    module Terremark
      class Ecloud

        class Real
          basic_request :get_vapp
        end

        class Mock
          def get_vapp(vapp_uri)
            xml = nil

            if vapp_and_vdc = vapp_and_vdc_from_vapp_uri(vapp_uri)
              xml = generate_get_vapp_response(*vapp_and_vdc)
            end

            if xml
              mock_it 200, xml, "Content-Type" => "application/vnd.vmware.vcloud.vApp+xml"
            else
              mock_error 200, "401 Unauthorized"
            end
          end

          private

          def generate_get_vapp_response(vapp, vdc)
            builder = Builder::XmlMarkup.new
            builder.VApp(xmlns.merge(
                                     :href => vapp[:href],
                                     :type => "application/vnd.vmware.vcloud.vApp+xml",
                                     :name => vapp[:name],
                                     :status => 2
                                     )) do
              builder.Link(:rel => "up", :href => vdc[:href], :type => "application/vnd.vmware.vcloud.vdc+xml")

              builder.NetworkConnectionSection(:xmlns => "http://schemas.dmtf.org/ovf/envelope/1") do
                builder.NetworkConnection(:Network => "Internal", :xmlns => "http://www.vmware.com/vcloud/v0.8") do
                  builder.IpAddress vapp[:ip]
                end
              end

              builder.OperatingSystemSection(
                                             "d2p1:id" => 4,
                                             :xmlns => "http://schemas.dmtf.org/ovf/envelope/1",
                                             "xmlns:d2p1" => "http://schemas.dmtf.org/ovf/envelope/1") do
                builder.Info "The kind of installed guest operating system"
                builder.Description "Red Hat Enterprise Linux 5 (64-bit)"
              end

              builder.VirtualHardwareSection(:xmlns => "http://schemas.dmtf.org/ovf/envelope/1") do
                builder.Info
                builder.System
                builder.Item do
                  # CPUs
                  builder.VirtualQuantity vapp[:cpus] || 1
                  builder.ResourceType 3
                end
                builder.Item do
                  # memory
                  builder.VirtualQuantity vapp[:memory] || 1024
                  builder.ResourceType 4
                end
                builder.Item do
                  # SCSI controller
                  builder.Address 0
                  builder.ResourceType 6
                  builder.InstanceId 3
                end
                builder.Item do
                  # Hard Disk 1
                  builder.Parent 3
                  builder.VirtualQuantity vapp[:disks].first[:size] * 1024 # MB
                  builder.HostResource vapp[:disks].first[:size] * 1024 # MB
                  builder.ResourceType 17
                  builder.AddressOnParent 0
                end
              end
            end
          end
        end
      end
    end
  end
end
