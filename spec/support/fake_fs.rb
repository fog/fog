# http://www.springone2gx.com/blog/scott_leberknight/2010/05/missing_the_each_line_method_in_fakefs_version_0_2_1_add_it_
module FakeFS
  class File
    def each_line
      File.readlines(self.path).each { |line| yield line }
    end
  end
end
