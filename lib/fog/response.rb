module Fog  
  class Response

    attr_accessor :body, :headers, :request, :status

    def initialize
      @body = ''
      @headers = {}
    end

  end
end
