shared_examples_for "Flavors" do

  describe "#get" do

    it "should return a matching flavor if one exists" do
      get = @flavors.get(subject.id)
      subject.attributes.should == get.attributes
    end

    it "should return nil if no matching server exists" do
      @flavors.get('0').should be_nil
    end

  end

end
