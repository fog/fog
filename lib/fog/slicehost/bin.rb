module Slicehost
  class << self
    if Fog.credentials[:slicehost_password]

      def initialized?
        true
      end

      def [](service)
        @@connections ||= Hash.new do |hash, key|
          hash[key] = case key
          when :compute
            Fog::Slicehost::Compute.new
          when :slices
            location = caller.first
            warning = "[yellow][WARN] Slicehost[:blocks] is deprecated, use Bluebox[:compute] instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
            Fog::Slicehost::Compute.new
          end
        end
        @@connections[service]
      end

      def services
        [:compute]
      end

      for collection in Fog::Slicehost::Compute.collections
        module_eval <<-EOS, __FILE__, __LINE__
          def #{collection}
            self[:compute].#{collection}
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
