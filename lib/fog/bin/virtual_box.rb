module VirtualBox # deviates from other bin stuff to accomodate gem
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Compute::VirtualBox
      else
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Logger.warning("VirtualBox[:compute] is deprecated, use Compute[:virtualbox] instead")
          Fog::Compute.new(:provider => 'VirtualBox')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def available?
      availability = if Gem::Specification.respond_to?(:find_all_by_name)
        !Gem::Specification.find_all_by_name('virtualbox').empty? # newest rubygems
      else
        !Gem.source_index.find_name('virtualbox').empty? # legacy
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
      Fog::VirtualBox.services
    end

  end
end
