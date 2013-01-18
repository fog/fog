class HP < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :block_storage
        Fog::HP::BlockStorage
      when :cdn
        Fog::CDN::HP
      when :compute
        Fog::Compute::HP
      when :storage
        Fog::Storage::HP
      else
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :block_storage
          Fog::HP::BlockStorage.new
        when :cdn
          Fog::Logger.warning("HP[:cdn] is deprecated, use CDN[:hp] instead")
          Fog::CDN.new(:provider => 'HP')
        when :compute
          Fog::Logger.warning("HP[:compute] is deprecated, use Compute[:hp] instead")
          Fog::Compute.new(:provider => 'HP')
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
