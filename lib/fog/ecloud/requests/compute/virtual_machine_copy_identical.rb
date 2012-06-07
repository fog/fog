module Fog
  module Compute
    class Ecloud
      module Shared

        def validate_create_server_options_identical(template_uri, options)
          required_opts = [:name, :row, :group, :source]
          unless required_opts.all? { |opt| options.has_key?(opt) }
            raise ArgumentError.new("Required data missing: #{(required_opts - options.keys).map(&:inspect).join(", ")}")
          end

          options
        end

        def build_request_body_identical(options)
          xml = Builder::XmlMarkup.new
          xml.CopyIdenticalVirtualMachine(:name => options[:name]) do
            xml.Source(:href => options[:source], :type => "application/vnd.tmrk.cloud.virtualMachine")
            xml.Layout do
              xml.NewRow options[:row]
              xml.NewGroup options[:group]
            end
            xml.Description options[:description]
          end
        end
      end

      class Real

        def virtual_machine_copy_identical(template_uri, options)
          options = validate_create_server_options_identical(template_uri, options)
          body = build_request_body_identical(options)
          request(
            :expects => 201,
            :method => 'POST',
            :headers => {},
            :body => body,
            :uri => template_uri,
            :parse => true
          )
        end
      end
    end
  end
end
