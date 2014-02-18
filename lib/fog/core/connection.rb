module Fog
  class Connection

    def initialize(url, persistent=false, params={})
      Excon.defaults[:headers]['User-Agent'] ||= "fog/#{Fog::VERSION}"
      @excon = Excon.new(url, params)
      @persistent = persistent
    end

    def request(params, &block)
      unless @persistent
        reset
      end
      unless block_given?
        if (parser = params.delete(:parser))
          body = Nokogiri::XML::SAX::PushParser.new(parser)
          params[:response_block] = lambda { |chunk, remaining, total| body << chunk }
        end
      end

      response = @excon.request(params, &block)

      if parser
        body.finish
        response.body = parser.response
      end

      response
    end

    def reset
      @excon.reset
    end

  end
end
