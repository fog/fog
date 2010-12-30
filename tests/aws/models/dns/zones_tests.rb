Shindo.tests('AWS::DNS | zones collection', ['aws']) do

  zones_tests(AWS[:dns], {}, false)

end
