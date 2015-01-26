require 'fog/core/model'

module Fog
  module Compute
    class XenServer
      class StorageManager < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/6.2.0/1.0/en_gb/api/?c=SM

        identity :reference

        attribute :capabilities
        attribute :configuration
        attribute :copyright
        attribute :driver_filename
        attribute :features
        attribute :description,               :aliases => :name_description
        attribute :name,                      :aliases => :name_label
        attribute :other_config
        attribute :required_api_version
        attribute :type
        attribute :uuid
        attribute :vendor
        attribute :version
      end
    end
  end
end
