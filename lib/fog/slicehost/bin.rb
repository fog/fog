module Slicehost
  class << self
    if Fog.credentials[:slicehost_password]

      def initialized?
        true
      end

      def [](service)
        @@connections ||= Hash.new do |hash, key|
          credentials = Fog.credentials.reject do |k,v|
            ![:slicehost_password].include?(k)
          end
          hash[key] = case key
          when :slices
            Fog::Slicehost.new(credentials)
          end
        end
        @@connections[service]
      end

      def flavors
        self[:slices].flavors
      end

      def images
        self[:slices].images
      end

      def servers
        self[:slices].servers
      end

    else

      def initialized?
        false
      end

    end
  end
end
