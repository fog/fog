source "http://moo-repo.wdf.sap.corp:8080/rubygemsorg"
source "http://moo-repo.wdf.sap.corp:8080/geminabox/"
#source "https://rubygems.org"

group :development, :test do
  # This is here because gemspec doesn't support require: false
  gem "netrc", :require => false
  gem "octokit", :require => false
end

gemspec
