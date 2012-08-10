class Vsphere < Fog::Bin
  class << self

    def class_for(key)
      case key
        when :compute
          Fog::Compute::Vsphere
        when :storage
          Fog::Storage::Vsphere
        when :highavailability
          Fog::HA::Vsphere
        else
          raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
                      when :compute
                        Fog::Compute.new(:provider => 'Vsphere')
                      when :storage
                        Fog::Storage.new(:provider => 'Vsphere')
                      when :highavailability
                        Fog::Highavailability::new(:provider => 'Vsphere')
                      else
                        raise ArgumentError, "Unrecognized service: #{key.inspect}"
                    end
      end
      @@connections[service]
    end

    def services
      Fog::Vsphere.services
    end

  end
end
