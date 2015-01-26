Shindo.tests("Fog::Joyent[:analytics] | instrumentation requests", %w{joyent}) do

  @analytics = Fog::Joyent[:analytics]

  @instrumentation_schema = {
      'id' => String,
      'module' => String,
      'stat' => String,
      'predicate' => Hash,
      'decomposition' => [String],
      'value-dimension' => Integer,
      'value-arity' => String,
      'retention-time' => Integer,
      'granularity' => Integer,
      'idle-max' => Integer,
      'transformations' => [String],
      'persist-data' => Fog::Boolean,
      'crtime' => Integer,
      'value-scope' => String,
      'uris' => [
          {
              'uri' => String,
              'name' => String
          }
      ]
  }

  tests('#create_instrumentation').data_matches_schema(@instrumentation_schema) do
    @analytics.create_instrumentation.body
  end

  tests('#list_instrumentations') do
    data_matches_schema(@instrumentation_schema) do
      @analytics.list_instrumentations.body.first
    end

    returns(Array) { @analytics.list_instrumentations.body.class }
  end

  tests('#delete_instrumentation') do
    returns(204) { @analytics.delete_instrumentation(Fog::Joyent::Analytics::Mock.data[:instrumentation]['id']).status }
  end

end
