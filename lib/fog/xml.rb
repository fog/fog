require "nokogiri"
require "fog/core/parser"

module Fog

  # @note Extracting XML components out of core is a work in progress.
  #
  # The {XML} module includes functionality that is common between APIs using
  # XML to send and receive data.
  #
  # The intent is to provide common code for provider APIs using XML but not
  # require it for those using JSON.
  #
  # @todo Add +require "fog/xml"+ and/or +include Fog::XML+ to providers using
  #   its services
  #
  module XML
  end
end

require "fog/xml/sax_parser_connection"
