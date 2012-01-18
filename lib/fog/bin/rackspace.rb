class Rackspace < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :cdn
        Fog::CDN::Rackspace
      when :compute
        Fog::Compute::Rackspace
      when :storage
        Fog::Storage::Rackspace
      when :load_balancers
        Fog::Rackspace::LoadBalancers
      when :dns
        Fog::DNS::Rackspace
      else
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :cdn
          Fog::Logger.warning("Rackspace[:cdn] is not recommended, use CDN[:rackspace] for portability")
          Fog::CDN.new(:provider => 'Rackspace')
        when :compute
          Fog::Logger.warning("Rackspace[:compute] is not recommended, use Compute[:rackspace] for portability")
          Fog::Compute.new(:provider => 'Rackspace')
        when :dns
          Fog::DNS.new(:provider => 'Rackspace')
        when :load_balancers
          Fog::Rackspace::LoadBalancers.new
        when :storage
          Fog::Logger.warning("Rackspace[:storage] is not recommended, use Storage[:rackspace] for portability")
          Fog::Storage.new(:provider => 'Rackspace')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::Rackspace.services
    end

  end
end
