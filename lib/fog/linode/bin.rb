module Linode
  class << self
    if Fog.credentials[:linode_api_key]

      def initialized?
        true
      end

      def [](service)
        @@connections ||= Hash.new do |hash, key|
          hash[key] = case key
          when :compute
            Fog::Linode::Compute.new
          when :linode
            location = caller.first
            warning = "[yellow][WARN] Linode[:linode] is deprecated, use Linode[:compute] instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
            Fog::Linode::Compute.new
          end
        end
        @@connections[service]
      end

      def services
        [:compute]
      end

    else

      def initialized?
        false
      end

    end
  end
end
