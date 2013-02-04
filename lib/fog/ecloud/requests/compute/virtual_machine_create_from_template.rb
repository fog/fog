module Fog
  module Compute
    class Ecloud
      module Shared

        def validate_create_server_options(template_uri, options)
          required_opts = [:name, :cpus, :memory, :row, :group, :customization, :network_uri]
          if options[:customization] == :windows
            required_opts.push(:windows_password)
          else
            required_opts.push(:ssh_key_uri)
          end
          unless required_opts.all? { |opt| options.has_key?(opt) }
            raise ArgumentError.new("Required data missing: #{(required_opts - options.keys).map(&:inspect).join(", ")}")
          end

          options[:network_uri] = options[:network_uri].is_a?(String) ? [options[:network_uri]] : options[:network_uri]
          options[:network_uri].map! do |uri|
            network = get_network(uri).body
            if options[:ips]
              ip = options[:ips][options[:network_uri].index(uri)]
            end
            {:href => uri, :name => network[:name], :ip => ip}
          end
          options[:template_uri] = template_uri
          options
        end

        def build_request_body(options)
          xml = Builder::XmlMarkup.new
          xml.CreateVirtualMachine(:name => options[:name]) do
            xml.ProcessorCount options[:cpus]
            xml.Memory do
              xml.Unit "MB"
              xml.Value options[:memory]
            end
            xml.Layout do
              xml.NewRow options[:row]
              xml.NewGroup options[:group]
            end
            xml.Description options[:description]
            xml.Tags do
              options[:tags].each do |tag|
                xml.Tag tag
              end
            end
            if options[:customization] == :windows
              xml.WindowsCustomization do
                xml.NetworkSettings do
                  xml.NetworkAdapterSettings do
                    options[:network_uri].each do |uri|
                      xml.NetworkAdapter do
                        xml.Network(:href => uri[:href], :name => uri[:name], :type => "application/vnd.tmrk.cloud.network")
                        xml.IpAddress uri[:ip]
                      end
                    end
                  end
                  if options[:dns_settings]
                    xml.DnsSettings do
                      xml.PrimaryDns options[:dns_settings][:primary_dns]
                      if options[:dns_settings][:secondary_dns]
                        xml.SecondaryDns options[:dns_settings][:secondary_dns]
                      end
                    end
                  end
                end
                xml.Password options[:windows_password]
                if options[:windows_license_key]
                  xml.LicenseKey options[:windows_license_key]
                end
              end
            else
              xml.LinuxCustomization do
                xml.NetworkSettings do
                  xml.NetworkAdapterSettings do
                    options[:network_uri] = options[:network_uri].is_a?(String) ? [options[:network_uri]] : options[:network_uri]
                    options[:network_uri].each do |uri|
                      xml.NetworkAdapter do
                        xml.Network(:href => uri[:href], :name => uri[:name], :type => "application/vnd.tmrk.cloud.network")
                        xml.IpAddress uri[:ip]
                      end
                    end
                  end
                  if options[:dns_settings]
                    xml.DnsSettings do
                      xml.PrimaryDns options[:dns_settings][:primary_dns]
                      if options[:dns_settings][:secondary_dns]
                        xml.SecondaryDns options[:dns_settings][:secondary_dns]
                      end
                    end
                  end
                end
                xml.SshKey(:href => options[:ssh_key_uri])
              end
            end
            xml.PoweredOn options[:powered_on]
            xml.Template(:href => options[:template_uri], :type => options[:template_type])
          end
        end
      end

      class Real
        def virtual_machine_create_from_template(template_uri, options)
          options = validate_create_server_options(template_uri, options)

          request(
            :expects => 201,
            :method  => 'POST',
            :body    => build_request_body(options),
            :uri     => options[:uri],
            :parse   => true
          )
        end
      end

      class Mock
        def virtual_machine_create_from_template(template_uri, options)
          options                      = validate_create_server_options(template_uri, options)
          server_id                    = Fog::Mock.random_numbers(7).to_i
          row_id                       = Fog::Mock.random_numbers(6).to_i
          group_id                     = Fog::Mock.random_numbers(6).to_i
          template_id, compute_pool_id = template_uri.match(/\/templates\/(\d+)\/computepools\/(\d+)$/).captures
          compute_pool                 = self.data[:compute_pools][compute_pool_id.to_i].dup
          environment                  = self.data[:environments][compute_pool[:environment_id]]
          layout                       = self.data[:layouts][environment[:id]]
          networks                     = options[:network_uri]
          nics                         = networks.each_with_index.map do |network, i|
            {
              :UnitNumber => i.to_s,
              :Name       => "Network adapter #{i}",
              :MacAddress => Fog::Ecloud.mac_address,
              :Network    => Fog::Ecloud.keep(network, :name, :href, :type),
            }
          end

          links = [Fog::Ecloud.keep(compute_pool, :name, :href, :type), Fog::Ecloud.keep(environment, :name, :href, :type)]
          networks.each do |network|
            links << Fog::Ecloud.keep(network, :name, :href, :type)
            network_id = id_from_uri(network[:href])
            ip = self.data[:networks][network_id][:IpAddresses][:IpAddress].detect { |ip| ip[:id] = network[:ip] }
            ip[:DetectedOn] = {:href => "/cloudapi/ecloud/networkhosts/#{server_id}", :name => options[:name], :type => "application/vnd.tmrk.cloud.networkHost"}
            ip[:Host]       = {:href => "/cloudapi/ecloud/networkhosts/#{server_id}", :name => options[:name], :type => "application/vnd.tmrk.cloud.networkHost"}
          end

          server = {
            :href                  => "/cloudapi/ecloud/virtualmachines/#{server_id}",
            :name                  => options[:name],
            :type                  => "application/vnd.tmrk.cloud.virtualMachine",
            :Description           => options[:description],
            :Status                => "Deployed",
            :HardwareConfiguration => {
              :href => "/cloudapi/ecloud/virtualmachines/#{server_id}/hardwareconfiguration",
              :type => "application/vnd.tmrk.cloud.virtualMachineHardware",
              :Links => {
                :Link => {
                  :href => "/cloudapi/ecloud/virtualmachines/#{server_id}",
                  :name => options[:name],
                  :type => "application/vnd.tmrk.cloud.virtualMachine",
                  :rel  => "up",
                }
              },
              :ProcessorCount => options[:cpus],
              :Memory => {
                :Unit  => "MB",
                :Value => options[:memory],
              },
              :Disks => {
                :Disk => [{
                  :Index => "0",
                  :Name  => "Hard Disk 1",
                  :Size  => {
                    :Unit  => "GB",
                    :Value => "25",
                  },
                }],
              },
              :Nics => {
                :Nic => nics,
              },
            },
            :IpAddresses => {
              :AssignedIpAddresses => {
                :Networks => {
                  :Network => self.data[:networks].dup.values,
                }
              }
            },
            :Links => { :Link => links },
          }

          row = {
            :id => row_id,
            :name => options[:row],
            :href => "/cloudapi/ecloud/layoutrows/#{row_id}",
            :type => "application/vnd.tmrk.cloud.layoutRow",
            :Links => {
              :Link => [
                Fog::Ecloud.keep(environment, :name, :href, :type)
              ],
            },
            :Index => 0,
            :Groups => {
              :Group => [
              ],
            },
            :environment_id => environment[:id],
          }

          group = {
            :id => group_id,
            :name => options[:group],
            :href => "/cloudapi/ecloud/layoutgroups/#{group_id}",
            :type => "application/vnd.tmrk.cloud.layoutGroup",
            :Links => {
              :Link => [
                Fog::Ecloud.keep(row, :name, :href, :type),
              ],
            },
            :Index => 0,
            :VirtualMachines => {
              :VirtualMachine => [
                server,
              ],
            },
            :row_id => row_id,
          }
          row[:Groups][:Group].push(group)
          layout[:Rows][:Row].push(row)

          server.merge!(:OperatingSystem => options[:operating_system].merge(:type => "application/vnd.tmrk.cloud.operatingSystem")) if options[:operating_system]

          server_response = response(:body =>  server)

          server.merge!(:compute_pool_id => compute_pool[:id])

          self.data[:servers][server_id] = server
          self.data[:rows][row_id]       = row
          self.data[:groups][group_id]   = group

          server_response
        end
      end
    end
  end
end
