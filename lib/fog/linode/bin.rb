module Linode
  class << self
    if Fog.credentials[:linode_api_key]

      def initialized?
        true
      end

      def [](service)
        @@connections ||= Hash.new do |hash, key|
          credentials = Fog.credentials.reject do |k,v|
            ![:linode_api_key].include?(k)
          end
          hash[key] = case key
          when :linode
            Fog::Linode.new(credentials)
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
