require "fog/xml"

module Fog
  # @deprecated Use {Fog::Core::Connection} or {XML::SAXParserConnection} if you
  #   require the response body to be parsed.
  #
  # The Connection class is a wrapper around an instance of Excon::Connection
  # supporting {#request} and {#reset} only.
  #
  # {#request} includes an option to perform SAX parsing for XML APIs.
  #
  # @see https://github.com/geemus/excon/blob/master/lib/excon/connection.rb
  #
  class Connection < Fog::XML::Connection
    def request(params, &block)
      if params.key?(:parser)
        Fog::Logger.deprecation("Fog::Connection is deprecated use Fog::XML::Connection instead [light_black](#{caller.first})[/]")
      else
        Fog::Logger.deprecation("Fog::Connection is deprecated use Fog::Core::Connection instead [light_black](#{caller.first})[/]")
      end
      super(params)
    end
  end
end
