Shindo.tests('AWS::AutoScaling | instances', ['aws', 'auto_scaling_m']) do

  collection_tests(AWS[:auto_scaling].instances, {}, false)

end
