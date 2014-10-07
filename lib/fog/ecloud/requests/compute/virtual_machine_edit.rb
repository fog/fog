module Fog
  module Compute
    class Ecloud
      module Shared
        def validate_edit_server_options(options)
          required_opts = [:name]
          unless required_opts.all? { |opt| options.key?(opt) }
            raise ArgumentError.new("Required data missing: #{(required_opts - options.keys).map(&:inspect).join(", ")}")
          end
        end

        def build_request_body_edit(options)
          xml = Builder::XmlMarkup.new
          xml.VirtualMachine(:name => options[:name]) do
            if options[:description]
              xml.Description options[:description]
            end
            if options[:tags]
              xml.Tags do
                options[:tags].each do |tag|
                  xml.Tag tag
                end
              end
            end
          end
        end
      end

      class Real
        def virtual_machine_edit(vm_uri, options)
          validate_edit_server_options(options)
          body = build_request_body_edit(options)
          request(
            :expects => [202,204],
            :method => 'PUT',
            :headers => {},
            :body => body,
            :uri => vm_uri,
            :parse => true
          )
        end
      end
    end
  end
end
