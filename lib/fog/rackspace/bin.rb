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

      def services
        [:files, :servers]
      end

      for collection in Fog::Rackspace::Files.collections
        module_eval <<-EOS, __FILE__, __LINE__
          def #{collection}
            self[:files].#{collection}
          end
        EOS
      end

      for collection in Fog::Rackspace::Servers.collections
        module_eval <<-EOS, __FILE__, __LINE__
          def #{collection}
            self[:servers].#{collection}
          end
        EOS
      end

    else

      def initialized?
        false
      end

    end
  end
end