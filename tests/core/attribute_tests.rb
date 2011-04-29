class FogAttributeTestModel < Fog::Model
  identity  :id
  attribute :key, :aliases => 'keys', :squash => "id"
  attribute :time, :type => :time
end

Shindo.tests('Fog::Attributes', 'core') do

  @model = FogAttributeTestModel.new

  tests('squash') do

    tests('"keys" => {:id => "value"}').returns('value') do
      @model.merge_attributes("keys" => {:id => "value"})
      @model.key
    end

    tests('"keys" => {"id" => "value"}').returns('value') do
      @model.merge_attributes("keys" => {'id' => "value"})
      @model.key
    end

  end

  tests(':type => :time') do

    @time  = Time.now

    tests(':time => nil').returns(nil) do
      @model.merge_attributes(:time => nil)
      @model.time
    end

    tests(':time => ""').returns('') do
      @model.merge_attributes(:time => '')
      @model.time
    end

    tests(':time => "#{@time.to_s}"').returns(Time.parse(@time.to_s)) do
      @model.merge_attributes(:time => @time.to_s)
      @model.time
    end

  end

  tests("comparisons") do
    model       = FogAttributeTestModel.new(:id => 'aaa')
    model_copy  = FogAttributeTestModel.new(:id => 'aaa')
    later_model = FogAttributeTestModel.new(:id => 'zzz')
    tests("<=>") do
      tests('0').returns(0) { model <=> model_copy }
      tests('1').returns(1) { later_model <=> model }
      tests('-1').returns(-1) { model <=> later_model }
      tests('uncomparable').returns(nil) { model <=> '' }
    end
    tests("==").returns(true) { model == model_copy }
    tests("<").returns(true) { model < later_model }

  end

end
