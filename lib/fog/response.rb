module Fog  
  class Response

    attr_accessor :status, :headers, :body

    def initialize
      @body = ''
      @headers = {}
    end

  end
end
