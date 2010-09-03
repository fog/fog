module GoGrid
  class << self
    if Fog.credentials[:go_grid_api_key] && Fog.credentials[:go_grid_shared_secret]

      def initialized?
        true
      end

      def [](service)
        @@connections ||= Hash.new do |hash, key|
          hash[key] = case key
          when :go_grid
            Fog::GoGrid.new
          end
        end
        @@connections[service]
      end

      def services
        [:go_grid]
      end

    else

      def initialized?
        false
      end

    end
  end
end
