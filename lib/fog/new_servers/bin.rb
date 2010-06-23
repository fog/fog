module NewServers
  class << self
    if Fog.credentials[:new_servers_password] && Fog.credentials[:new_servers_username]

      def initialized?
        true
      end

      def [](service)
        @@connections ||= Hash.new do |hash, key|
          credentials = Fog.credentials.reject do |k,v|
            ![:new_servers_password, :new_servers_username].include?(k)
          end
          hash[key] = case key
          when :new_servers
            Fog::NewServers.new(credentials)
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
