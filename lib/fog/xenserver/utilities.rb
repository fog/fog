class Hash
  def symbolize_keys!
    keys.each do |key|
      self[(key.to_sym rescue key)] = delete(key) if key.respond_to?(:to_sym) && !key.is_a?(Fixnum)
    end
    self
  end
end
