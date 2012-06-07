module Fog
  module Compute
    class Ecloud
      class Real

        def virtual_machine_edit_hardware_configuration(vm_uri, data)
          validate_data([:cpus, :memory, :disks, :nics], data)
          body = build_request_body_edit_hardware_configuration(data)
          request(
            :expects => 202,
            :method => 'PUT',
            :headers => {},
            :body => body,
            :uri => vm_uri,
            :parse => true
          )
        end

        def build_request_body_edit_hardware_configuration(data)
          xml = Builder::XmlMarkup.new
          xml.HardwareConfiguration do
            xml.ProcessorCount data[:cpus]
            xml.Memory do
              xml.Unit data[:memory][:Unit]
              xml.Value data[:memory][:Value]
            end
            xml.Disks do
              data[:disks].each do |disk|
                xml.Disk do
                  xml.Index disk[:Index]
                  xml.Size do
                    xml.Unit "GB"
                    xml.Value disk[:Size][:Value]
                  end
                end
              end
            end
            xml.Nics do
              data[:nics].each do |nic|
                xml.Nic do
                  xml.UnitNumber nic[:UnitNumber]
                  xml.MacAddress nic[:MacAddress]
                  xml.Network(:href => nic[:Network][:href], :name => nic[:Network][:name], :type => "application/vnd.tmrk.cloud.network") do
                  end
                end
              end
            end
          end    
        end
      end
    end
  end
end
