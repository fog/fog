Shindo.tests('Fog::Compute[:hp] | user agent', ['hp', 'user_agent']) do
  tests('default for HP providers').returns("hpfog/#{Fog::HP::VERSION}") do
    pending if Fog.mocking?
    conn = Fog::Compute[:hp]
    conn.instance_variable_get(:@connection_options)[:headers]['User-Agent']
  end

  tests('overriden by clients').returns("hpfog/#{Fog::HP::VERSION} (TesterClient/1.0.0)") do
    pending if Fog.mocking?
    conn = Fog::Compute::HP.new(:user_agent => "TesterClient/1.0.0")
    conn.instance_variable_get(:@connection_options)[:headers]['User-Agent']
  end
end
