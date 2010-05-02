module Local
  class << self
    if Fog.credentials[:local_root]

      def initialized?
        true
      end

      def [](service)
        @@connections ||= Hash.new do |hash, key|
          credentials = Fog.credentials.reject do |k,v|
            ![:local_root].include?(k)
          end
          hash[key] = case key
          when :files
            Fog::Local.new(credentials)
          end
        end
        @@connections[service]
      end

      def directories
        self[:files].directories
      end

    else

      def initialized?
        false
      end

    end
  end
end
