module Fog
  module Compute
    class Ecloud
      module Shared
        def validate_edit_node_service_options(options)
          required_opts = [:name, :enabled]
          unless required_opts.all? { |opt| options.key?(opt) }
            raise ArgumentError.new("Required data missing: #{(required_opts - options.keys).map(&:inspect).join(", ")}")
          end
        end

        def build_node_service_body_edit(options)
          xml = Builder::XmlMarkup.new
          xml.NodeService(:name => options[:name]) do
            xml.Enabled options[:enabled]
            if options[:description]
              xml.Description options[:description]
            end
          end
        end
      end

      class Real
        def node_service_edit(options)
          validate_edit_node_service_options(options)
          body = build_node_service_body_edit(options)
          request(
            :expects => 202,
            :method => 'PUT',
            :headers => {},
            :body => body,
            :uri => options[:uri],
            :parse => true
          )
        end
      end
    end
  end
end
