require 'shindo_helper'
Shindo.tests("Fog::Compute[:hp] | addresses", ['hp']) do

  collection_tests(Fog::Compute[:hp].addresses, {}, true)

end
