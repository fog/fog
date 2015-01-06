require 'fog/aws/service_mapper'

class AWS < Fog::Bin
  def self.services
    Fog::AWS::ServiceMapper.services
  end

  def self.[](key)
    Fog::AWS::ServiceMapper[key]
  end

  def self.class_for(key)
    Fog::AWS::ServiceMapper.class_for(key)
  end
end
