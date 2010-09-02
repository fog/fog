module Slicehost
  class << self
    if Fog.credentials[:slicehost_password]

      def initialized?
        true
      end

      def [](service)
        @@connections ||= Hash.new do |hash, key|
          hash[key] = case key
          when :slices
            Fog::Slicehost.new
          end
        end
        @@connections[service]
      end

      for collection in Fog::Slicehost.collections
        module_eval <<-EOS, __FILE__, __LINE__
          def #{collection}
            self[:slices].#{collection}
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
