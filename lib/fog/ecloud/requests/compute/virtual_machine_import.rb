module Fog
  module Compute
    class Ecloud
      module Shared

        def validate_import_server_options(template_uri, options)
          required_opts = [:name, :cpus, :memory, :row, :group, :network_uri, :catalog_network_name]
          unless required_opts.all? { |opt| options.has_key?(opt) }
            raise ArgumentError.new("Required data missing: #{(required_opts - options.keys).map(&:inspect).join(", ")}")
          end

          options[:network_uri] = options[:network_uri].is_a?(String) ? [options[:network_uri]] : options[:network_uri]
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
            :method => 'POST',
            :headers => {},
            :body => build_request_body_import(options),
            :uri => options[:uri],
            :parse => true
          )
        end
      end
    end
  end
end
