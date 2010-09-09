shared_examples_for "Servers" do

  describe "#all" do

    it "should include persisted servers" do
      subject.save
      @servers.all.map {|server| server.id}.should include(subject.id)
    end

  end

  describe "#get" do

    it "should return a matching server if one exists" do
      subject.save
      subject.wait_for { ready? }
      get = @servers.get(subject.id)
      subject.attributes.should == get.attributes
    end

    it "should return nil if no matching server exists" do
      @servers.get('i-00000000').should be_nil
    end

  end

  describe "#reload" do

    it "should reset attributes to remote state" do
      subject.save
      servers = @servers.all
      reloaded = servers.reload
      servers.attributes.should == reloaded.attributes
    end

  end

end
