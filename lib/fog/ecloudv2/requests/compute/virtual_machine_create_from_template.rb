module Fog
  module Compute
    class Ecloudv2
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

          if template_uri.scan(/\/catalog\/\d+/)[0]
            options[:template_type] = get_catalog_item(template_uri).body[:type]
          elsif template_uri.scan(/\/templates\/\d+/)[0]
            options[:template_type] = get_template(template_uri).body[:type]
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
            :method => 'POST',
            :headers => {},
            :body => build_request_body(options),
            :uri => options[:uri],
            :parse => true
          )
        end
      end
    end
  end
end
