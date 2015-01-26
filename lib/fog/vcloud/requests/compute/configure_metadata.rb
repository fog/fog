module Fog
  module Vcloud
    class Compute
      class Real
        def configure_metadata(opts= {})
          valid_opts = [:key, :value, :href]
          unless valid_opts.all? { |opt| opts.key?(opt) }
            raise ArgumentError.new("Required data missing: #{(valid_opts - opts.keys).map(&:inspect).join(", ")}")
          end

          body = <<EOF
          <Metadata
             type="application/vnd.vmware.vcloud.metadata+xml"
             xmlns="http://www.vmware.com/vcloud/v1.5">
             <MetadataEntry>
                <Key>#{opts[:key]}</Key>
                <Value>#{opts[:value]}</Value>
             </MetadataEntry>
          </Metadata>
EOF

          request(
            :body     => body,
            :expects  => 202, # it returns a task object
            :headers  => {'Content-Type' => 'application/vnd.vmware.vcloud.metadata+xml' },
            :method   => 'POST',
            :uri      => opts[:href],
            :parse    => true
          )
        end
      end
    end
  end
end
