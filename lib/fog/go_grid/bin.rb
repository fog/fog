module GoGrid
  class << self
    if Fog.credentials[:go_grid_api_key] && Fog.credentials[:go_grid_shared_secret]

      def initialized?
        true
      end

      def [](service)
        @@connections ||= Hash.new do |hash, key|
          credentials = Fog.credentials.reject do |k,v|
            ![:go_grid_api_key, :go_grid_shared_secret].include?(k)
          end
          hash[key] = case key
          when :go_grid
            Fog::GoGrid.new(credentials)
          end
        end
        @@connections[service]
      end

    else

      def initialized?
        false
      end

    end
  end
end
