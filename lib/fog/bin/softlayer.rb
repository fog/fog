#
# Author:: Matt Eldridge (<matt.eldridge@us.ibm.com>)
# © Copyright IBM Corporation 2014.
#
# LICENSE: MIT (http://opensource.org/licenses/MIT)
#

class Softlayer < Fog::Bin
  class << self
    def class_for(key)
      case key
        when :compute
          Fog::Compute::Softlayer
        when :dns
          Fog::DNS::Softlayer
        when :network
          Fog::Network::Softlayer
        when :storage
          Fog::Storage::Softlayer
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
                      when :compute
                        Fog::Logger.warning("Softlayer[:compute] is not recommended, use Compute[:aws] for portability")
                        Fog::Compute.new(:provider => :softlayer)
                      when :dns
                        Fog::Logger.warning("Softlayer[:dns] is not recommended, use DNS[:aws] for portability")
                        Fog::DNS.new(:provider => :softlayer)
                      when :network
                        Fog::Network.new(:provider => :softlayer)
                      when :storage
                        Fog::Storage.new(:provider => :softlayer)
                      else
                        raise ArgumentError, "Unrecognized service: #{key.inspect}"
                    end
      end
      @@connections[service]
    end

    def services
      Fog::Softlayer.services
    end
  end
end

