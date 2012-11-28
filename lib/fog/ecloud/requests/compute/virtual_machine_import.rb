module Fog
  module Compute
    class Ecloud
      module Shared

        def validate_import_server_options(template_uri, options)
          required_opts = [:name, :cpus, :memory, :row, :group, :network_uri, :catalog_network_name]
          unless required_opts.all? { |opt| options.has_key?(opt) }
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
        # => #<Excon::Errors::BadRequest: Expected(201) <=> Actual(400 Bad Request)
        # response => #<Excon::Response:0x007fc011b82cd8 @body="<Error message=\"The import could not be started because the specified environment and catalog item are not located in the same data center.\" majorErrorCode=\"400\" minorErrorCode=\"InvalidCatalogItem\"/>", @headers={"Cache-Control"=>"private", "Content-Type"=>"application/vnd.tmrk.cloud.error", "X-Responding-Host"=>"us01.services.enterprisecloud.terremark.com", "x-tmrk-currentuser"=>"/cloudapi/ecloud/admin/users/8274", "x-tmrk-token"=>"ecloud-0B3672A7DBB8-57A2-456B-C338-D4D29AB9-8B65F50CF82F4BA5-8274", "Date"=>"Wed, 28 Nov 2012 20:12:57 GMT", "Content-Length"=>"199"}, @status=400>>
        # response => #<Excon::Response:0x007fc00ead86a0 @body="<Error message=\"The import could not be started because one or more networks assigned are not valid for the intended environment.\" majorErrorCode=\"400\" minorErrorCode=\"InvalidNetwork\"/>", @headers={"Cache-Control"=>"private", "Content-Type"=>"application/vnd.tmrk.cloud.error", "X-Responding-Host"=>"us01.services.enterprisecloud.terremark.com", "x-tmrk-currentuser"=>"/cloudapi/ecloud/admin/users/8274", "x-tmrk-token"=>"ecloud-0B3672A7DBB8-57A2-456B-C338-D4D29AB9-8B65F50CF82F4BA5-8274", "Date"=>"Wed, 28 Nov 2012 20:16:43 GMT", "Content-Length"=>"185"}, @status=400>>
        def virtual_machine_import(template_uri, options)
          options         = validate_import_server_options(template_uri, options)

          compute_pool_id = options[:uri].match(/computePools\/(\d+)/)[1].to_i
          compute_pool    = self.data[:compute_pools][compute_pool_id].dup
          environment     = self.data[:environments][compute_pool[:environment_id]]
          networks        = options[:network_uri].map{|nuri| self.data[:networks][id_from_uri(nuri)].dup}
          server_id       = Fog::Mock.random_numbers(6).to_i
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

          server.merge!(:OperatingSystem => options[:operating_system].merge(:type => "application/vnd.tmrk.cloud.operatingSystem")) if options[:operating_system]

          server_response = response(body: server)

          server.merge!(:compute_pool_id => compute_pool_id)

          self.data[:servers][server_id] = server

          server_response
        end
      end
    end
  end
end
