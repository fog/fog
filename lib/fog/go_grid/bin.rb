module GoGrid
  class << self
    if Fog.credentials[:go_grid_api_key] && Fog.credentials[:go_grid_shared_secret]

      def initialized?
        true
      end

      def [](service)
        @@connections ||= Hash.new do |hash, key|
          hash[key] = case key
          when :compute
            Fog::GoGrid::Compute.new
          when :servers
            location = caller.first
            warning = "[yellow][WARN] GoGrid[:servers] is deprecated, use GoGrid[:compute] instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
            Fog::GoGrid::Compute.new
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
