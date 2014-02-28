Shindo.tests('Fog#timeout', 'core') do
  tests('timeout').returns(FOG_TESTING_TIMEOUT) do
    Fog.timeout
  end

  tests('timeout = 300').returns(300) do
    Fog.timeout = 300
    Fog.timeout
  end
end
