Shindo.tests('Rackspace | url_encoding', ['rackspace']) do
  returns("is%20this%20my%20file%3F.jpg") { Fog::Rackspace.escape("is this my file?.jpg") }
  returns("foo/bar") { Fog::Rackspace.escape("foo/bar", "/") }
  returns("foo%2Fbar") { Fog::Rackspace.escape("foo/bar", "0") }
end
