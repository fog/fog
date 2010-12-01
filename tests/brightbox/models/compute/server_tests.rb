Shindo.tests('Brightbox::Compute | server model', ['brightbox']) do

  # image img-9vxqi = Ubuntu Maverick 10.10 server
  server_tests(Brightbox[:compute], {:image_id => 'img-9vxqi'}, false)

end
