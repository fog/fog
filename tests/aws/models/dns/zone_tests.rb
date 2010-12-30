Shindo.tests('AWS::DNS | zone model', ['aws']) do

  zone_tests(AWS[:dns], {}, false)

end
