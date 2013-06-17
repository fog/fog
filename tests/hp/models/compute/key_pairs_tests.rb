require 'shindo_helper'
Shindo.tests("Fog::Compute[:hp] | key_pairs", ['hp']) do

  collection_tests(Fog::Compute[:hp].key_pairs, {:name => 'fogkeyname'}, true)

end
