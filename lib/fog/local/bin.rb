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
            location = caller.first
            warning = "[yellow][WARN] Local[:files] is deprecated, use Local[:storage] instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
            Fog::Local::Storage.new
          when :storage
            Fog::Local::Storage.new
          end
        end
        @@connections[service]
      end

      def services
        [:storage]
      end

      for collection in Fog::Local::Storage.collections
        module_eval <<-EOS, __FILE__, __LINE__
          def #{collection}
            self[:storage].#{collection}
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
