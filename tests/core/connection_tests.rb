Shindo.tests('Fog::Core::Connection', ['core']) do

  raises(ArgumentError, "raises ArgumentError when no arguments given") do
    Fog::Core::Connection.new
  end

  tests('new("http://example.com")') do
    @instance = Fog::Core::Connection.new("http://example.com")
    responds_to([:request, :reset])

    tests('user agent').returns("fog/#{Fog::VERSION}") do
      @instance.instance_variable_get(:@excon).data[:headers]['User-Agent']
    end
  end

  tests('new("http://example.com", true)') do
    Fog::Core::Connection.new("http://example.com", true)
  end

  tests('new("http://example.com", false, options")') do
    options = {
      :debug_response => false
    }
    Fog::Core::Connection.new("http://example.com", true, options)
  end
end
