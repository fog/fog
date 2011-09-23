Shindo.tests('AWS::Elasticache | parameter groups', ['aws', 'elasticache']) do
  group_name = 'fog-test'
  description = 'Fog Test'

  pending if Fog.mocking?

  model_tests(
    AWS[:elasticache].parameter_groups,
    {:id => group_name, :description => description}, false
  )

  collection_tests(
    AWS[:elasticache].parameter_groups,
    {:id => group_name, :description => description}, false
  )

end
