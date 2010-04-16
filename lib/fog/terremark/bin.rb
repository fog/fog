module Terremark
  class << self
    if (Fog::Terremark::ECLOUD_OPTIONS.all? { |option| Fog.credentials.has_key?(option) } ) ||
       (Fog::Terremark::VCLOUD_OPTIONS.all? { |option| Fog.credentials.has_key?(option) } )

      def initialized?
        true
      end

      def terremark_service(service)
        case service
        when :ecloud
          Fog::Terremark::Ecloud
        when :vcloud
          Fog::Terremark::Vcloud
        else
          raise "Unsupported Terremark Service"
        end
      end

      def [](service)
        @@connections ||= Hash.new do |hash, key|
          credentials = Fog.credentials.reject do |k,v|
            case key
            when :ecloud
              !Fog::Terremark::ECLOUD_OPTIONS.include?(k)
            when :vcloud
              !Fog::Terremark::VCLOUD_OPTIONS.include?(k)
            end
          end
          case key
          when :ecloud
            hash[key] = Fog::Terremark::Ecloud.new(credentials)
          when :vcloud
            hash[key] = Fog::Terremark::Vcloud.new(credentials)
          else
            raise "Unsupported Terremark Service"
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
