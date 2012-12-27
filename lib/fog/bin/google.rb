module Google # deviates from other bin stuff to accomodate gem
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Compute::Google
      when :storage
        Fog::Storage::Google
      else 
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :storage
          Fog::Logger.warning("Google[:storage] is not recommended, use Storage[:google] for portability")
          Fog::Storage.new(:provider => 'Google')
        when :compute
          Fog::Logger.warning("Google[:compute] is not recommended, use Compute[:google] for portability")
          Fog::Compute.new(:provider => 'Google')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def account
      @@connections[:compute].account
    end

    def services
      Fog::Google.services
    end

    # based off of virtual_box.rb
    def available?
      availability = if Gem::Specification.respond_to?(:find_all_by_name)
        !Gem::Specification.find_all_by_name('google_api_client').empty? # newest rubygems
      else
        !Gem.source_index.find_name('google_api_client').empty? # legacy
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
  end
end
