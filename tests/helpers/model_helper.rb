def tests_models

  tests('model#save') do

    test('does not exist remotely before save') do
      !@collection.get(@model.identity)
    end

    test('succeeds') do
      @model.save
    end

    test('does exist remotely after save') do
      @model.save
      if @model.respond_to?(:ready?)
        @model.wait_for { ready? }
      end
      reloaded = @model.reload
      @model.attributes == reloaded.attributes
    end

  end

  test('model#reload') do
    if @model.respond_to?(:ready?)
      @model.wait_for { ready? }
    end
    reloaded = @model.reload
    @model.attributes == reloaded.attributes
  end

  test('collection#all includes persisted models') do
    @model.save
    @collection.all.map {|model| model.identity}.include? @model.identity
  end

  tests('collection#get') do

    test 'should return a matching model if one exists' do
      @model.save
      get = @collection.get(@model.identity)
      @model.attributes == get.attributes
    end

    test 'should return nil if no matching model exists' do
      !@collection.get('0')
    end

  end

  test('collection#reload') do
    @model.save
    @collection.all
    reloaded = @collection.reload
    @collection.attributes == reloaded.attributes
  end

  test('model#destroy') do
    if @model.respond_to?(:ready?)
      @model.wait_for{ ready? }
    end
    @model.destroy
  end

end
