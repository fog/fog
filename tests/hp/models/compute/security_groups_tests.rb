Shindo.tests("Fog::Compute[:hp] | security_groups", ['hp']) do

  collection_tests(Fog::Compute[:hp].security_groups, {:name => 'foggroupname', :description => 'foggroupdescription'}, true)

end
