module Fog
  class Compute

    def self.new(attributes)
      attributes = attributes.dup # prevent delete from having side effects
      case provider = attributes[:provider] # attributes.delete(:provider)
      when 'AWS'
        require 'fog/compute/aws'
        Fog::AWS::Compute.new(attributes)
      when 'Bluebox'
        require 'fog/compute/bluebox'
        Fog::Bluebox::Compute.new(attributes)
      when 'Brightbox'
        require 'fog/compute/brightbox'
        Fog::Brightbox::Compute.new(attributes)
      when 'Ecloud'
        require 'fog/compute/ecloud'
        Fog::Ecloud::Compute.new(attributes)
      when 'GoGrid'
        require 'fog/compute/go_grid'
        Fog::GoGrid::Compute.new(attributes)
      when 'Linode'
        require 'fog/compute/linode'
        Fog::Linode::Compute.new(attributes)
      when 'NewServers'
        require 'fog/compute/new_servers'
        Fog::NewServers::Compute.new(attributes)
      when 'Rackspace'
        require 'fog/compute/rackspace'
        Fog::Rackspace::Compute.new(attributes)
      when 'Slicehost'
        require 'fog/compute/slicehost'
        Fog::Slicehost::Compute.new(attributes)
      when 'VirtualBox'
        require 'fog/compute/virtual_box'
        Fog::VirtualBox::Compute.new(attributes)
      when 'Voxel'
        require 'fog/compute/voxel'
        Fog::Voxel::Compute.new(attributes)
      else
        raise ArgumentError.new("#{provider} is not a recognized compute provider")
      end
    end

  end
end
