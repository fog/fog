Shindo.tests('AWS::Storage | directory models', ['aws']) do

  @collection = AWS[:storage].directories
  @model = @collection.new(:key => Time.now.to_f.to_s)

  tests_models

end
