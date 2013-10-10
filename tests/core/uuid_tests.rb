Shindo.tests('Fog::UUID', 'core') do

  tests('supported?').succeeds do
    Fog::UUID.supported? == SecureRandom.respond_to?(:uuid)
  end

  if Fog::UUID.supported?
    tests('success').succeeds do
      Fog::UUID.uuid =~ /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
    end
  else
    tests('success').succeeds do
      raises(RuntimeError) { Fog::UUID.uuid }
    end
  end
end