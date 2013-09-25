require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module Ecloud
    ECLOUD_OPTIONS = [:ecloud_authentication_method]

    extend Fog::Provider

    service(:compute, 'ecloud/compute', 'Compute')

    def self.keep(hash, *keys)
      {}.tap do |kept|
        keys.each{|k| kept[k]= hash[k] if hash.key?(k)}
      end
    end

    def self.slice(hash, *keys)
      hash.dup.tap do |sliced|
        keys.each{|k| sliced.delete(k)}
      end
    end

    def self.ip_address
      4.times.map{ Fog::Mock.random_numbers(3) }.join(".")
    end

    def self.mac_address
      6.times.map{ Fog::Mock.random_numbers(2) }.join(":")
    end
  end
end
