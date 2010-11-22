
Given /^the BDD helper methods are available$/ do
  @version_dir = ::Fog::Bdd.core_dir
  @version_helper = ::Fog::Bdd.version_helper
end

When /^the "([^\"]*)" version is bumped$/ do |ver_num_type|
  FakeFS.activate!
    @version_helper.__send__( "bump_#{ver_num_type}" )
  FakeFS.deactivate!
end

When /^the version string is updated$/ do
  mm, m, p, b = @version_helper.major,  @version_helper.minor, @version_helper.patch, @version_helper.build
  ::Fog::Version::STRING.should == "#{mm}.#{m}.#{p}.#{b}"
end

Then /^the "([^\"]*)" version attribute is bumped similarly$/ do |ver_num_type|
  prev_ver = @version_helper.__send__( ver_num_type )
  FakeFS.activate!
    @version_helper.__send__( "bump_#{ver_num_type}" )
    pending("FakeFS being able to load, or fakefs-require gem improves") do
      @version_helper.__send__( ver_num_type ).should == prev_ver+1
    end
  FakeFS.deactivate!
end

Then /^the "([^\"]*)" version constant is bumped similarly$/ do |ver_num_type|
  prev_ver = ::Fog::Version.__send__(:const_get, "#{ver_num_type}".upcase.to_sym)
  FakeFS.activate!
    @version_helper.__send__("bump_#{ver_num_type.to_sym}")
    pending("FakeFS being able to fake load, or fakefs-require gem improves") do
      ::Fog::Version.__send__(:const_get,"#{ver_num_type}".upcase.to_sym).should == prev_ver+1
    end
  FakeFS.deactivate!
end

