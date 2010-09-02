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
            Fog::Bluebox.new
          end
        end
        @@connections[service]
      end

      for collection in Fog::Bluebox.collections
        module_eval <<-EOS, __FILE__, __LINE__
          def #{collection}
            self[:blocks].#{collection}
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
