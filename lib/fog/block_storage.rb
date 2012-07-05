module Fog
  module BlockStorage

    def self.[](provider)
      self.new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup # Prevent delete from having side effects
      case provider = attributes.delete(:provider).to_s.downcase.to_sym
      when :hp
        require 'fog/hp/block_storage'
        Fog::BlockStorage::HP.new(attributes)
      else
        raise ArgumentError.new("#{provider} is not a recognized block storage provider")
      end
    end

    def self.providers
      Fog.services[:block_storage]
    end

  end
end
