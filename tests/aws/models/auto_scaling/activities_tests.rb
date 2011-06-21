Shindo.tests('AWS::AutoScaling | activities', ['aws', 'auto_scaling_m']) do

  collection_tests(AWS[:auto_scaling].activities, {}, false)

end
