Shindo.tests('Fog#timeout', 'core') do
  tests('timeout').returns(600) do
    Fog.timeout
  end

  tests('timeout = 300').returns(300) do
    Fog.timeout = 300
    Fog.timeout
  end
end
