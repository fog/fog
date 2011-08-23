def aws_storage
  @storage ||= begin
    storage = Fog::Storage::new({
        :provider => 'AWS',
        :aws_access_key_id => '',
        :aws_secret_access_key => ''})
    storage.stub(:request) { |hash| hash }
    storage
  end
end
