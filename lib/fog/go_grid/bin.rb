module GoGrid
  class << self
    if Fog.credentials[:go_grid_api_key] && Fog.credentials[:go_grid_shared_secret]

      def initialized?
        true
      end

      def [](service)
        @@connections ||= Hash.new do |hash, key|
          hash[key] = case key
          when :servers
            Fog::GoGrid::Servers.new
          end
        end
        @@connections[service]
      end

      def services
        [:servers]
      end

    else

      def initialized?
        false
      end

    end
  end
end
