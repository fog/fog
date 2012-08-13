module Fog
  class Connection

    def initialize(url, persistent=false, params={})
      # Set a User-Agent
      set_user_agent_header("fog/#{Fog::VERSION}", params)
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

    private

    def set_user_agent_header(str, params)
      user_agent = {'User-Agent' => str}
      if params[:headers]
        params[:headers] = user_agent.merge!(params[:headers])
      else
        params[:headers] = user_agent
      end
    end
  end
end
