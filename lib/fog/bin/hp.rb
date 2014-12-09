class HP < Fog::Bin
  class << self
    def class_for(key)
      case key
      when :block_storage
        Fog::HP::BlockStorage
      when :block_storage_v2
        Fog::HP::BlockStorageV2
      when :cdn
        Fog::CDN::HP
      when :compute
        Fog::Compute::HP
      when :dns
        Fog::HP::DNS
      when :lb
        Fog::HP::LB
      when :network
        Fog::HP::Network
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
          Fog::Logger.deprecation "HP Cloud Block Storage V1 service will be soon deprecated. Please use `Fog::HP::BlockStorageV2` provider to use latest HP Cloud Block Storage service."
          Fog::HP::BlockStorage.new
        when :block_storage_v2
          Fog::HP::BlockStorageV2.new
        when :cdn
          Fog::Logger.warning("HP[:cdn] is deprecated, use CDN[:hp] instead")
          Fog::CDN.new(:provider => 'HP')
        when :compute
          Fog::Logger.warning("HP[:compute] is deprecated, use Compute[:hp] instead")
          Fog::Compute.new(:provider => 'HP')
        when :dns
          Fog::HP::DNS.new
        when :lb
          Fog::HP::LB.new
        when :network
          Fog::HP::Network.new
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
