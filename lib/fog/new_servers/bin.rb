module NewServers
  class << self
    if Fog.credentials[:new_servers_password] && Fog.credentials[:new_servers_username]

      def initialized?
        true
      end

      def [](service)
        @@connections ||= Hash.new do |hash, key|
          hash[key] = case key
          when :new_servers
            Fog::NewServers.new
          end
        end
        @@connections[service]
      end

      def services
        [:new_servers]
      end

    else

      def initialized?
        false
      end

    end
  end
end
