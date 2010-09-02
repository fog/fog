module Rackspace
  class << self
    if Fog.credentials[:rackspace_api_key] && Fog.credentials[:rackspace_username]

      def initialized?
        true
      end

      def [](service)
        @@connections ||= Hash.new do |hash, key|
          hash[key] = case key
          when :files
            Fog::Rackspace::Files.new
          when :servers
            Fog::Rackspace::Servers.new
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