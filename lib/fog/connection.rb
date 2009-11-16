unless Fog.mocking?

  module Fog
    class Connection

      def initialize(url)
        @excon = Excon.new(url)
      end

      def request(params)
        if parser = params.delete(:parser)
          body = Nokogiri::XML::SAX::PushParser.new(parser)
          params[:block] = lambda { |chunk| body << chunk }
        end

        response = @excon.request(params)

        if parser
          body.finish
          response.body = parser.response
        end

        response
      end

    end
  end

else

  module Fog
    class Connection

      def initialize(url)
      end

      def request(params)
      end

    end
  end

end
