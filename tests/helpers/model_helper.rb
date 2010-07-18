def tests_models

  after do
    if @model && !@model.new_record?
      if @model.respond_to?(:ready?)
        @model.wait_for { ready? }
      end
      @model.destroy
    end
  end

  tests('collection') do

    test('#all includes persisted models') do
      @model.save
      @collection.all.map {|model| model.identity}.include? @model.identity
    end

    tests('#get') do

      test 'should return a matching model if one exists' do
        @model.save
        get = @collection.get(@model.identity)
        @model.attributes == get.attributes
      end

      test 'should return nil if no matching model exists' do
        !@collection.get('0')
      end

    end

    test('#reload') do
      @model.save
      @collection.all
      reloaded = @collection.reload
      @collection.attributes == reloaded.attributes
    end

  end

  tests('model') do

    test('#reload') do
      @model.save
      if @model.respond_to?(:ready?)
        @model.wait_for { ready? }
      end
      reloaded = @model.reload
      @model.attributes == reloaded.attributes
    end

    tests('#save') do

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

  end

end
