module Fog
  module Compute
    class Ecloud
      module Shared
        def validate_import_server_options(template_uri, options)
          required_opts = [:name, :cpus, :memory, :row, :group, :network_uri, :catalog_network_name]
          unless required_opts.all? { |opt| options.key?(opt) }
            raise ArgumentError.new("Required data missing: #{(required_opts - options.keys).map(&:inspect).join(", ")}")
          end

          options[:network_uri] = [*options[:network_uri]]
          options[:template_uri] = template_uri
          options
        end

        def build_request_body_import(options)
          xml = Builder::XmlMarkup.new
          xml.ImportVirtualMachine(:name => options[:name]) do
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
            if options[:tags]
              xml.Tags do
                options[:tags].each do |tag|
                  xml.Tag tag
                end
              end
            end
            xml.CatalogEntry(:href => options[:template_uri])
            xml.NetworkMappings do
              xml.NetworkMapping(:name => options[:catalog_network_name]) do
                xml.Network(:href => options[:network_uri][0])
              end
            end
            if options[:operating_system]
              xml.OperatingSystem(:href => options[:operating_system][:href], :name => options[:operating_system][:name], :type => "application/vnd.tmrk.cloud.operatingSystem")
            end
          end
        end
      end

      class Real
        def virtual_machine_import(template_uri, options)
          options = validate_import_server_options(template_uri, options)

          request(
            :expects => 201,
            :method  => 'POST',
            :body    => build_request_body_import(options),
            :uri     => options[:uri],
            :parse   => true
          )
        end
      end

      class Mock
        def virtual_machine_import(template_uri, options)
          options         = validate_import_server_options(template_uri, options)

          compute_pool_id = options[:uri].match(/computePools\/(\d+)/)[1].to_i
          compute_pool    = self.data[:compute_pools][compute_pool_id].dup
          environment     = self.data[:environments][compute_pool[:environment_id]]
          networks        = options[:network_uri].map{|nuri| self.data[:networks][id_from_uri(nuri)].dup}
          server_id       = Fog::Mock.random_numbers(6).to_i
          row_id          = Fog::Mock.random_numbers(6).to_i
          group_id        = Fog::Mock.random_numbers(6).to_i
          nics            = networks.each_with_index.map do |network, i|
            {
              :UnitNumber => i.to_s,
              :Name       => "Network adapter #{i}",
              :MacAddress => Fog::Ecloud.mac_address,
              :Network    => Fog::Ecloud.keep(network, :name, :href, :type)
            }
          end

          links = [Fog::Ecloud.keep(compute_pool, :name, :href, :type), Fog::Ecloud.keep(environment, :name, :href, :type)]
          networks.each{|network| links << Fog::Ecloud.keep(network, :name, :href, :type)}
          server = {
            :href        => "/cloudapi/ecloud/virtualmachines/#{server_id}",
            :name        => options[:name],
            :type        => "application/vnd.tmrk.cloud.virtualMachine",
            :Description => options[:description],
            :Status      => "Deployed",
            :PoweredOn   => "false",
            :HardwareConfiguration => {
              :href => "/cloudapi/ecloud/virtualmachines/#{server_id}/hardwareconfiguration",
              :type => "application/vnd.tmrk.cloud.virtualMachineHardware",
              :Links => {
                :Link => {
                  :href => "/cloudapi/ecloud/virtualmachines/#{server_id}",
                  :name => options[:name],
                  :type => "application/vnd.tmrk.cloud.virtualMachine",
                  :rel  => "up"
                }
              },
              :ProcessorCount => options[:cpus],
              :Memory => {
                :Unit  => "MB",
                :Value => options[:memory],
              },
              :Disks => { # Default drive
                :Disk => [{
                  :Index => "0",
                  :Name  => "Hard Disk 1",
                  :Size  => {
                    :Unit  => "GB",
                    :Value => "25"
                  },
                }],
              },
              :Nics => {
                :Nic => nics,
              },
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

          server.merge!(:compute_pool_id => compute_pool_id)

          self.data[:servers][server_id] = server
          self.data[:rows][row_id]       = row
          self.data[:groups][group_id]   = group

          server_response
        end
      end
    end
  end
end
