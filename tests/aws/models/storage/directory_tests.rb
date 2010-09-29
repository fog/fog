Shindo.tests('AWS::Storage | directory models', ['aws']) do

  @collection = AWS[:storage].directories
  @model = @collection.new(:key => Time.now.to_f.to_s)
  @non_id = 'not_a_directory'

  tests_model

end
