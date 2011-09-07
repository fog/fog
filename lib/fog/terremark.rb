require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

require 'fog/terremark/shared'
require 'fog/terremark/parser'
require 'fog/terremark/vcloud'

module Fog
  module Terremark
    VCLOUD_OPTIONS = [:terremark_vcloud_username, :terremark_vcloud_password]
  end
end
