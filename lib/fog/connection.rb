module Fog
  class Connection

    def initialize(url)
      @excon = Excon.new(url)
    end

    def request(params, &block)
      unless block_given?
        if (parser = params.delete(:parser))
          body = Nokogiri::XML::SAX::PushParser.new(parser)
          block = lambda { |chunk| body << chunk }
        end
      end

      response = @excon.request(params, &block)

      if parser
        body.finish
        response.body = parser.response
      end

      response
    end

  end
end
