Shindo.tests('Fog#wait_for', 'core') do
  tests("success") do
    tests('Fog#wait_for').formats(:duration => Integer) do
      Fog.wait_for(1) { true }
    end
  end

  tests("failure") do
    tests('Fog#wait_for').raises(Fog::Errors::TimeoutError) do
      Fog.wait_for(2) { false }
    end
  end
end
