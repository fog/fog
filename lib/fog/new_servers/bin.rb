module NewServers
  class << self
    if Fog.credentials[:new_servers_password] && Fog.credentials[:new_servers_username]

      def initialized?
        true
      end

      def [](service)
        @@connections ||= Hash.new do |hash, key|
          hash[key] = case key
          when :compute
            Fog::NewServers::Compute.new
          when :new_servers
            location = caller.first
            warning = "[yellow][WARN] NewServers[:servers] is deprecated, use NewServers[:compute] instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
            Fog::NewServers::Compute.new
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
