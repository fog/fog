class HP < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :cdn
        Fog::CDN::HP
      when :compute
        Fog::Compute::HP
      when :storage
        Fog::Storage::HP
      else
        # @todo Replace most instances of ArgumentError with NotImplementedError
        # @todo For a list of widely supported Exceptions, see:
        # => http://www.zenspider.com/Languages/Ruby/QuickRef.html#35
        raise ArgumentError, "Unrecognized #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :cdn
          Fog::Logger.warning("HP[:cdn] is deprecated, use CDN[:hp] instead")
          Fog::CDN.new(:provider => 'HP')
        when :compute
          Fog::Logger.warning("HP[:compute] is deprecated, use Compute[:hp] instead")
          Fog::Compute.new(:provider => 'HP')
        when :dns
          Fog::DNS.new(:provider => 'HP')
        when :storage
          Fog::Logger.warning("HP[:storage] is deprecated, use Storage[:hp] instead")
          Fog::Storage.new(:provider => 'HP')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::HP.services
    end

  end
end
