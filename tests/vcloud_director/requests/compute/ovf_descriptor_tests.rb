Shindo.tests('Compute::VcloudDirector | ovf requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new

  tests('Get current organization') do
    session = @service.get_current_session.body
    link = session[:Link].detect do |l|
      l[:type] == 'application/vnd.vmware.vcloud.org+xml'
    end
    @org = @service.get_organization(link[:href].split('/').last).body
  end

  tests('Get first vDC') do
    session = @service.get_current_session.body
    link = @org[:Link].detect do |l|
      l[:type] == 'application/vnd.vmware.vcloud.vdc+xml'
    end
    @vdc = @service.get_vdc(link[:href].split('/').last).body
    @vdc[:ResourceEntities][:ResourceEntity] = [@vdc[:ResourceEntities][:ResourceEntity]] if @vdc[:ResourceEntities][:ResourceEntity].is_a?(Hash)
  end

  # 'Envelope' is the outer type of the parsed XML document.
  tests('#get_vapp_ovf_descriptor').returns('Envelope') do
    pending if Fog.mocking?
    link = @vdc[:ResourceEntities][:ResourceEntity].detect do |l|
      l[:type] == 'application/vnd.vmware.vcloud.vApp+xml'
    end
    pending if link.nil?
    body = @service.get_vapp_ovf_descriptor(link[:href].split('/').last).body
    Nokogiri::XML::Document.parse(body).children.first.name
  end

  # 'Envelope' is the outer type of the parsed XML document.
  tests('#get_vapp_template_ovf_descriptor').returns('Envelope') do
    pending if Fog.mocking?
    link = @vdc[:ResourceEntities][:ResourceEntity].detect do |l|
      l[:type] == 'application/vnd.vmware.vcloud.vAppTemplate+xml'
    end
    pending if link.nil?
    body = @service.get_vapp_template_ovf_descriptor(link[:href].split('/').last).body
    Nokogiri::XML::Document.parse(body).children.first.name
  end

end
