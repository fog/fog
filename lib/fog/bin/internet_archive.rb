class InternetArchive < Fog::Bin
  class << self
    def class_for(key)
      case key
      when :storage
        Fog::Storage::InternetArchive
      else
        # @todo Replace most instances of ArgumentError with NotImplementedError
        # @todo For a list of widely supported Exceptions, see:
        # => http://www.zenspider.com/Languages/Ruby/QuickRef.html#35
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :storage
          Fog::Logger.warning("InternetArchive[:storage] is not recommended, use Storage[:aws] for portability")
          Fog::Storage.new(:provider => 'InternetArchive')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::InternetArchive.services
    end
  end
end
