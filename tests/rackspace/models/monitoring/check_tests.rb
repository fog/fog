Shindo.tests('Fog::Rackspace::Monitoring | check', ['rackspace','rackspace_monitoring']) do
  pending if Fog.mocking?
  service = Fog::Rackspace::Monitoring.new

  tests('#entity=') do
    tests('should create new entity if object is a string') do
      check = Fog::Rackspace::Monitoring::Check.new
      id = "123123"
      check.entity = "123123"
      returns(Fog::Rackspace::Monitoring::Entity) { check.entity.class }
      returns(id) { check.entity.id }
    end
    tests('should set entity if object is an entity') do
      id = "555"
      entity = Fog::Rackspace::Monitoring::Entity.new(:id => id)
      check = Fog::Rackspace::Monitoring::Check.new
      check.entity = entity
      returns(Fog::Rackspace::Monitoring::Entity) { check.entity.class }
      returns(id) { check.entity.id }
    end
  end

  begin
    @entity = service.entities.create :label => "fog_#{Time.now.to_i.to_s}"

    options = CHECK_CREATE_OPTIONS.merge(:label => "fog_#{Time.now.to_i.to_s}", :entity => @entity)
    collection = service.checks(:entity => @entity)
    model_tests(collection, options, false) do
      tests('#update').succeeds do
        new_label = "new_label_#{Time.now.to_i.to_s}"
        @instance.label = new_label
        timeout = 2
        @instance.timeout = 2
        @instance.save
        @instance.timeout = -1 # blank out timeout just to make sure
        @instance.label = nil # blank out label just to make sure
        @instance.reload
        returns(timeout) { @instance.timeout }
        returns(new_label) { @instance.label}
      end

      tests('#metrics').succeeds do
        @instance.metrics
      end
    end
  ensure
    @entity.destroy if @entity
  end
end
