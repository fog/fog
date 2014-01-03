Shindo.tests("Fog::Joyent[:analytics] | instrumentations", %w{joyent models instrumentation }) do
  collection_tests(Fog::Joyent[:analytics].instrumentations, {:joyent_module => 'cpu', :stat => 'usage'}, true)
end
