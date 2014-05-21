module Fog
  module Compute
    class Ecloud
      module Shared
        def validate_upload_file_options(options)
          required_opts = [:file, :path, :credentials]
          unless required_opts.all? { |opt| options.key?(opt) }
            raise ArgumentError.new("Required data missing: #{(required_opts - options.keys).map(&:inspect).join(", ")}")
          end
        end
      end

      class Real
        def virtual_machine_upload_file(vm_uri, options)
          validate_upload_file_options(options)
          request(
            :expects => 204,
            :method => 'POST',
            :headers => {'Content-Type' => 'application/octet-stream', 'X-Guest-User' => options[:credentials][:user], 'X-Guest-Password' => options[:credentials][:password], 'Content-Range' => "0-#{options[:file].bytesize - 1}/#{options[:file].bytesize}"},
            :body => options[:file],
            :uri => vm_uri + "?path=#{options[:path]}",
            :parse => true
          )
        end
      end
    end
  end
end
