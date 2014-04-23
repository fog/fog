require 'fog/core/model'

module Fog
  module Compute
    class OpenNebula

      class Network < Fog::Model

        identity :id
        attribute :name
        attribute :uid
        attribute :gid
        attribute :description
        attribute :vlan

        def initialize(attributes = {})
          super
        end

	def description=(str)
	  @description=str
	end

	def description
	  return "" if @description.nil?
	  return @description
	end

	def vlan=(str)
	  @vlan=str
	end

	def vlan
	  return "" if @vlan.nil?
	  return @vlan
	end

        def save
          raise Fog::Errors::Error.new('Creating a new network is not yet implemented. Contributions welcome!')
        end

        def shutdown
	  raise Fog::Errors::Error.new('Shutting down a new network is not yet implemented. Contributions welcome!')
        end

	def to_label
	  ret = ""
	  ret += "#{description} - " unless description.empty?
	  ret += "VLAN #{vlan} - " unless vlan.empty?
          ret += "#{name}"
	end

      end

    end
  end

end
