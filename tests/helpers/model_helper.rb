def tests_model
  tests_model_first
  tests_collection
  tests_model_last
end

def tests_model_first

  tests(@model.class) do

    test('#save') do
      @model.save
    end

    if @model.respond_to?(:ready?)
      @model.wait_for { ready? }
    end

    test('#reload') do
      reloaded = @model.reload
      @model.attributes == reloaded.attributes
    end

  end

end

def tests_collection

  tests(@collection.class) do

    test('collection#all includes persisted models') do
      @collection.all.map {|model| model.identity}.include?(@model.identity)
    end

    tests('collection#get') do

      test 'should return a matching model if one exists' do
        get = @collection.get(@model.identity)
        @model.attributes == get.attributes
      end

      test 'should return nil if no matching model exists' do
        !@collection.get(@non_id)
      end

    end

    test('collection#reload') do
      @collection.all
      reloaded = @collection.reload
      @collection.attributes == reloaded.attributes
    end

  end

end

def tests_model_last

  tests(@model.class) do

    test('#destroy') do
      if @model.respond_to?(:ready?)
        @model.wait_for{ ready? }
      end
      @model.destroy
    end

  end

end