Shindo.tests('Fog::Rackspace::Monitoring | datapoints', ['rackspace','rackspace_monitoring']) do
  pending if Fog.mocking?
  service = Fog::Rackspace::Monitoring.new

  begin
    label = "fog_#{Time.now.to_i.to_s}"
    @entity = service.entities.create :label => label
    @check = service.checks.create CHECK_CREATE_OPTIONS.merge(:label => label, :entity => @entity)
    sleep(@check.period + 30) unless Fog.mocking?
    @metric = service.metrics(:check => @check).first

    tests('#datapoints').succeeds do
     service.data_points(:metric => @metric).fetch({ :from => ((Time.now.to_i * 1000) - (3600 * 1000)) })
    end
  ensure
    @check.destroy rescue nil if @check
    @entity.destroy rescue nil if @entity
  end
end
