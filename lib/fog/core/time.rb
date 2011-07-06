module Fog
  class Time < ::Time

    DAYS = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
    MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']

    def self.now
      at((::Time.now - offset).to_i)
    end

    def self.now=(new_now)
      old_now = ::Time.now
      @offset = old_now - new_now
      new_now
    end

    def self.offset
      @offset ||= 0
    end

    def to_date_header
      self.utc.strftime("#{DAYS[self.utc.wday]}, %d #{MONTHS[self.utc.month - 1]} %Y %H:%M:%S +0000")
    end

  end
end
