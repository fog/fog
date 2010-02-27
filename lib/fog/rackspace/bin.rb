module Rackspace
  class << self
    if Fog.credentials[:rackspace_api_key] && Fog.credentials[:rackspace_username]

      def initialized?
        true
      end

      def [](service)
        @@connections ||= Hash.new do |hash, key|
          credentials = Fog.credentials.reject do |k,v|
            ![:rackspace_api_key, :rackspace_username].include?(k)
          end
          hash[key] = case key
          when :files
            Fog::Rackspace::Files.new(credentials)
          when :servers
            Fog::Rackspace::Servers.new(credentials)
          end
        end
        @@connections[service]
      end

      def directories
        self[:files].directories
      end

      def flavors
        self[:servers].flavors
      end

      def images
        self[:servers].images
      end

      def servers
        self[:servers].servers
      end
      
    else

      def initialized?
        false
      end

    end
  end
end