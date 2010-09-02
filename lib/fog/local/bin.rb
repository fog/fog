module Local
  class << self
    if Fog.credentials[:local_root]

      def initialized?
        true
      end

      def [](service)
        @@connections ||= Hash.new do |hash, key|
          hash[key] = case key
          when :files
            Fog::Local.new
          end
        end
        @@connections[service]
      end

      for collection in Fog::Local.collections
        module_eval <<-EOS, __FILE__, __LINE__
          def #{collection}
            self[:files].#{collection}
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
