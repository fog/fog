module Google
  class << self

    if Fog.credentials[:google_storage_access_key_id] && Fog.credentials[:google_storage_secret_access_key]

      def initialized?
        true
      end

      def [](service)
        @@connections ||= Hash.new do |hash, key|
          hash[key] = case key
          when :storage
            Fog::Google::Storage.new
          end
        end
        @@connections[service]
      end

      def services
        [:storage]
      end

      for collection in Fog::Google::Storage.collections
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
