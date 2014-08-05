require 'fog/core'

module Fog
  module Vsphere
    extend Fog::Provider

    module Errors
      class ServiceError < Fog::Errors::Error; end
      class SecurityError < ServiceError; end
      class NotFound < ServiceError; end
    end

    service(:compute, 'Compute')

    # This helper was originally added as Fog.class_as_string and moved to core but only used here
    def self.class_from_string classname, defaultpath=""
      if classname and classname.is_a? String then
        chain = classname.split("::")
        klass = Kernel
        chain.each do |klass_string|
          klass = klass.const_get klass_string
        end
        if klass.is_a? Class then
          klass
        elsif defaultpath != nil then
          class_from_string((defaultpath.split("::")+chain).join("::"), nil)
        else
          nil
        end
      elsif classname and classname.is_a? Class then
        classname
      else
        nil
      end
    rescue NameError
      defaultpath != nil ? class_from_string((defaultpath.split("::")+chain).join("::"), nil) : nil
    end
  end
end
