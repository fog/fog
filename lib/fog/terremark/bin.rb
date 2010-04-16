module Terremark
  class << self
    if Fog.credentials[:terremark_password] && Fog.credentials[:terremark_username]

      def initialized?
        true
      end

      def [](service)
        @@connections ||= Hash.new do |hash, key|
          credentials = Fog.credentials.reject do |k,v|
            ![:terremark_username, :terremark_password].include?(k)
          end
          hash[key] = Fog::Terremark.new(credentials.merge(:terremark_service => key))
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
