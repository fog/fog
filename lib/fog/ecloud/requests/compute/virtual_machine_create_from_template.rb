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

          #if template_uri.scan(/\/catalog\/\d+/)[0]
          #  options[:template_type] = get_catalog_item(template_uri).body[:type]
          #elsif template_uri.scan(/\/templates\/\d+/)[0]
          #  options[:template_type] = get_template(template_uri).body[:type]
          #end

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
              end
              xml.SshKey(:href => options[:ssh_key_uri])
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
          #response => #<Excon::Response:0x007fa75c7071e0 @body="<Error message=\"The server could not be created because the name of VM is not valid.\" majorErrorCode=\"400\" minorErrorCode=\"InvalidName\"/>", @headers={"Cache-Control"=>"private", "Content-Type"=>"application/vnd.tmrk.cloud.error", "X-Responding-Host"=>"us01.services.enterprisecloud.terremark.com", "x-tmrk-currentuser"=>"/cloudapi/ecloud/admin/users/8274", "x-tmrk-token"=>"ecloud-0B36739F41C7-581C-4BDF-1FA1-504EF398-8F18B899C767442E-8274", "Date"=>"Thu, 29 Nov 2012 19:06:20 GMT", "Content-Length"=>"137"}, @status=400>
          options                      = validate_create_server_options(template_uri, options)
          server_id                    = Fog::Mock.random_numbers(7).to_i
          template_id, compute_pool_id = template_uri.match(/\/templates\/(\d+)\/computepools\/(\d+)$/).captures
          compute_pool                 = self.data[:compute_pools][compute_pool_id.to_i].dup
          environment                  = self.data[:environments][compute_pool[:environment_id]]
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

          server.merge!(:OperatingSystem => options[:operating_system].merge(:type => "application/vnd.tmrk.cloud.operatingSystem")) if options[:operating_system]

          server_response = response(body: server)

          server.merge!(:compute_pool_id => compute_pool[:id])

          self.data[:servers][server_id] = server

          server_response
        end
      end
    end
  end
end
