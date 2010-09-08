module Bluebox
  class << self

    if Fog.credentials[:bluebox_api_key]

      def initialized?
        true
      end

      def [](service)
        @@connections ||= Hash.new do |hash, key|
          hash[key] = case key
          when :blocks
            location = caller.first
            warning = "[yellow][WARN] Bluebox[:blocks] is deprecated, use Bluebox[:compute] instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
            Fog::Bluebox::Compute.new
          when :compute
            Fog::Bluebox::Compute.new
          end
        end
        @@connections[service]
      end

      def services
        [:compute]
      end

      for collection in Fog::Bluebox::Compute.collections
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
