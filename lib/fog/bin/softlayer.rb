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
        else
          raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
                      when :compute
                        Fog::Logger.warning("Softlayer[:compute] is not recommended, use Compute[:softlayer] for portability")
                        Fog::Compute.new(:provider => 'Softlayer')
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
