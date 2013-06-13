module Fog

  # The Connection class is a wrapper around an instance of Excon::Connection
  # supporting {#request} and {#reset} only.
  #
  # {#request} includes an option to perform SAX parsing for XML APIs.
  #
  # @see https://github.com/geemus/excon/blob/master/lib/excon/connection.rb
  #
  class Connection

    # Prepares the connection and sets defaults for any future requests.
    #
    # @param [String] url The destination URL
    # @param persistent [Boolean]
    # @param [Hash] params
    # @option params [String] :body Default text to be sent over a socket. Only used if :body absent in Connection#request params
    # @option params [Hash<Symbol, String>] :headers The default headers to supply in a request. Only used if params[:headers] is not supplied to Connection#request
    # @option params [String] :host The destination host's reachable DNS name or IP, in the form of a String
    # @option params [String] :path Default path; appears after 'scheme://host:port/'. Only used if params[:path] is not supplied to Connection#request
    # @option params [Fixnum] :port The port on which to connect, to the destination host
    # @option params [Hash]   :query Default query; appended to the 'scheme://host:port/path/' in the form of '?key=value'. Will only be used if params[:query] is not supplied to Connection#request
    # @option params [String] :scheme The protocol; 'https' causes OpenSSL to be used
    # @option params [String] :proxy Proxy server; e.g. 'http://myproxy.com:8888'
    # @option params [Fixnum] :retry_limit Set how many times we'll retry a failed request.  (Default 4)
    # @option params [Class] :instrumentor Responds to #instrument as in ActiveSupport::Notifications
    # @option params [String] :instrumentor_name Name prefix for #instrument events.  Defaults to 'excon'
    # @option params [Nokogiri::XML::SAX::Document] :parser
    #
    def initialize(url, persistent=false, params={})
      unless params.has_key?(:debug_response)
        params[:debug_response] = true
      end
      params[:headers] ||= {}
      params[:headers]['User-Agent'] ||= "fog/#{Fog::VERSION}"
      @excon = Excon.new(url, params)
      @persistent = persistent
    end

    # Makes a request using the connection using Excon
    #
    # @param [Hash] params
    # @option params [String] :body text to be sent over a socket
    # @option params [Hash<Symbol, String>] :headers The default headers to supply in a request
    # @option params [String] :host The destination host's reachable DNS name or IP, in the form of a String
    # @option params [String] :path appears after 'scheme://host:port/'
    # @option params [Fixnum] :port The port on which to connect, to the destination host
    # @option params [Hash]   :query appended to the 'scheme://host:port/path/' in the form of '?key=value'
    # @option params [String] :scheme The protocol; 'https' causes OpenSSL to be used
    # @option params [Proc] :response_block
    # @option params [Nokogiri::XML::SAX::Document] :parser
    #
    # @return [Excon::Response]
    #
    # @raise [Excon::Errors::StubNotFound]
    # @raise [Excon::Errors::Timeout]
    # @raise [Excon::Errors::SocketError]
    #
    def request(params, &block)
      unless @persistent
        reset
      end
      unless block_given?
        if (parser = params.delete(:parser))
          body = Nokogiri::XML::SAX::PushParser.new(parser)
          params[:response_block] = lambda do |chunk, remaining, total|
            body << chunk
          end
        end
      end

      response = @excon.request(params, &block)

      if parser
        body.finish
        response.body = parser.response
      end

      response
    end

    # Closes the connection
    #
    def reset
      @excon.reset
    end
  end
end
