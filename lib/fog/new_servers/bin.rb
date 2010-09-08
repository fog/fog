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
