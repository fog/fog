module Fog

  @mocking = false

  def self.mock!
    @mocking = true
  end

  def self.mock?
    @mocking
  end

  def self.mocking?
    @mocking
  end

  module Mock

    @delay = 1
    def self.delay
      @delay
    end

    def self.delay=(new_delay)
      raise ArgumentError, "delay must be non-negative" unless new_delay >= 0
      @delay = new_delay
    end

    def self.not_implemented
      raise Fog::Errors::MockNotImplemented.new("Contributions welcome!")
    end

    def self.random_base64(length)
      random_selection(
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
        length
      )
    end

    def self.random_hex(length)
      max = ('f' * length).to_i(16)
      rand(max).to_s(16).rjust(length, '0')
    end

    def self.random_letters(length)
      random_selection(
        'abcdefghijklmnopqrstuvwxyz',
        length
      )
    end

    def self.random_numbers(length)
      max = ('9' * length).to_i
      rand(max).to_s
    end

    def self.random_selection(characters, length)
      selection = ''
      length.times do
        position = rand(characters.length)
        selection << characters[position..position]
      end
      selection
    end

    def self.reset
      providers = Fog.providers.map{|p| eval("Fog::#{p}")}
      services = providers.map{|p| p.constants.map{|s| eval("#{p}::#{s}")}}.flatten
      services.select!{|s| s.constants.include?(:Mock)}

      services.each do |service|
        next unless service::Mock.respond_to?(:reset)
        service::Mock.reset
      end
    end

  end

end