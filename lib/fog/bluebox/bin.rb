module Bluebox
  class << self

    if Fog.credentials[:bluebox_api_key]

      def initialized?
        true
      end

      def [](service)
        @@connections ||= Hash.new do |hash, key|
          credentials = Fog.credentials.reject do |k,v|
            ![:bluebox_api_key, :bluebox_host, :bluebox_port, :bluebox_scheme].include?(k)
          end
          hash[key] = case key
          when :blocks
            Fog::Bluebox.new(credentials)
          end
        end
        @@connections[service]
      end

      def flavors
        self[:blocks].flavors
      end

      def images
        self[:blocks].images
      end

      def servers
        self[:blocks].servers
      end

    else

      def initialized?
        false
      end

    end
  end
end
