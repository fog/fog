module Fog
  module Compute
    class Ecloud
      module Shared

        def validate_edit_compute_pool_options(options)
          required_opts = [:name]
          unless required_opts.all? { |opt| options.has_key?(opt) }
            raise ArgumentError.new("Required data missing: #{(required_opts - options.keys).map(&:inspect).join(", ")}")
          end
        end

        def build_compute_pool_body_edit(options)
          xml = Builder::XmlMarkup.new
          xml.ComputePool(:name => options[:name]) do
          end    
        end
      end

      class Real

        def compute_pool_edit(options)
          validate_edit_compute_pool_options(options)
          body = build_compute_pool_body_edit(options)
          request(
            :expects => 200,
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
