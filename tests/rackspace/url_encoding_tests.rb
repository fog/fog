Shindo.tests('Rackspace | url_encoding', ['rackspace']) do
  returns( Fog::Rackspace.escape( "is this my file?.jpg" ) ) { "is%20this%20my%20file%3F.jpg" }
end
