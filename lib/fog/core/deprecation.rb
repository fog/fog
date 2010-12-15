module Fog
  module Deprecation

    def deprecate(older, newer)
      module_eval <<-EOS, __FILE__, __LINE__
        def #{older}(*args)
          Formatador.display_line("[yellow][WARN] #{self} => ##{older} is deprecated, use ##{newer} instead[/] [light_black](#{caller.first})[/]")
          send(:#{newer}, *args)
        end
      EOS
    end

    def self_deprecate(older, newer)
      module_eval <<-EOS, __FILE__, __LINE__
        def self.#{older}(*args)
          Formatador.display_line("[yellow][WARN] #{self} => ##{older} is deprecated, use ##{newer} instead[/] [light_black](#{caller.first})[/]")
          send(:#{newer}, *args)
        end
      EOS
    end

  end
end
