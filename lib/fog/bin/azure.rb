module Azure # deviates from other bin stuff to accomodate gem
  class << self
    def class_for(key)
      case key
      when :compute
        Fog::Compute::Azure
      else
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Logger.warning("Azure[:compute] is not recommended, use Compute[:azure] for portability")
          Fog::Compute.new(:provider => 'Azure')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def available?
      availability = true
      for service in services
        begin
          service = self.class_for(service)
          availability &&= service.requirements.all? { |requirement| Fog.credentials.include?(requirement) }
        rescue ArgumentError => e
          Fog::Logger.warning(e.message)
          availability = false
        rescue => e
          availability = false
        end
      end

      if availability
        for service in services
          for collection in self.class_for(service).collections
            unless self.respond_to?(collection)
              self.class_eval <<-EOS, __FILE__, __LINE__
                def self.#{collection}
                  self[:#{service}].#{collection}
                end
              EOS
            end
          end
        end
      end
      availability
    end

    def collections
      services.map {|service| self[service].collections}.flatten.sort_by {|service| service.to_s}
    end

    def services
      Fog::Azure.services
    end
  end
end
