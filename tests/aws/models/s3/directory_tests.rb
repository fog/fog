Shindo.tests('AWS::S3 | directory models', ['aws']) do

  @collection = AWS[:s3].directories
  @model = @collection.new(:key => Time.now.to_f.to_s)

  tests_models

end
