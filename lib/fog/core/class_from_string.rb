module Fog
   # get class by string or nil
   def self.class_from_string classname, defaultpath=""
     if classname and classname.is_a? String then
        chain = classname.split("::")
        klass = Kernel
        chain.each do |klass_string|
           klass = klass.const_get klass_string
        end
        if klass.is_a? Class then
           klass
        elsif defaultpath != nil then
           Fog.class_from_string((defaultpath.split("::")+chain).join("::"), nil)
        else
           nil
        end
     elsif classname and classname.is_a? Class then
        classname
     else
        nil
     end
   rescue NameError
     defaultpath != nil ? Fog.class_from_string((defaultpath.split("::")+chain).join("::"), nil) : nil
   end
end

