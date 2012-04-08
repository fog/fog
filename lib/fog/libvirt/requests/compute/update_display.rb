module Fog
  module Compute
    class Libvirt
      class Real
        def update_display(options = { })
          raise ArgumentError, "uuid is a required parameter" unless options.has_key? :uuid
          display          = { }
          display[:type]   = options[:type] || 'vnc'
          display[:port]   = (options[:port] || -1).to_s
          display[:listen] = options[:listen].to_s   if options[:listen]
          display[:passwd] = options[:password].to_s if options[:password]
          display[:autoport] = 'yes' if display[:port] == '-1'

          builder = Nokogiri::XML::Builder.new { graphics_ (display) }
          xml     = Nokogiri::XML(builder.to_xml).root.to_s

          client.lookup_domain_by_uuid(options[:uuid]).update_device(xml, 0)
          # if we got no exceptions, then we're good'
          true
        end
      end

      class Mock
        def update_display(options = { })
          raise ArgumentError, "uuid is a required parameter" unless options.has_key? :uuid
          true
        end
      end
    end
  end
end
