module Terremark
  class << self
    if Fog.credentials[:terremark_password] && Fog.credentials[:terremark_username]

      def initialized?
        true
      end

      def terremark_service
        @terremark_service ||= begin
          Fog.credentials[:terremark_service] || :vcloud
        end
      end

      def [](service)
        @@connections ||= Hash.new do |hash, key|
          credentials = Fog.credentials.reject do |k,v|
            ![:terremark_username, :terremark_password].include?(k)
          end
          hash[key] = Fog::Terremark.new(credentials.merge(:terremark_service => terremark_service))
        end
        @@connections[service]
      end

      def servers
        self[terremark_service].servers
      end

      def tasks
        self[terremark_service].tasks
      end

    else

      def initialized?
        false
      end

    end
  end
end
