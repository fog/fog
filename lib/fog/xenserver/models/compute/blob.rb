require 'fog/core/model'

module Fog
  module Compute
    class XenServer
      class Blob < Fog::Model
        # API Reference here:
        # http://docs.vmd.citrix.com/XenServer/6.2.0/1.0/en_gb/api/?c=blob

        identity :reference

        attribute :last_updated
        attribute :mime_type
        attribute :description,         :aliases => :name_description
        attribute :name,                :aliases => :name_label
        attribute :public
        attribute :size
        attribute :uuid
      end
    end
  end
end
