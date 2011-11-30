module Fog
  class Connection
    def initialize(url, persistent=false, params={})
    end

    def request(params, &block)
      Excon::Response.new(
        :body => File.read(File.expand_path(File.join(File.dirname(__FILE__),'..','..','data',params[:path].gsub(/^\//,'').gsub('/','_+_')))),
        :status => 200,
        :header => '')
    end
  end
end
