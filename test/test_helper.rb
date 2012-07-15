#
# A file used to test DATAWriter
# Is called by datawriter_test in a subshell that returns the output of the specifed method.
#

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)) + "/../lib")
require 'data-writer.rb'

module TestHelper
  class << self

    def write(string)
      DATAWriter.file("w+") do |w|
        w.write(string)
      end 
    end

    def read
      DATAWriter.file("r+") do |r|
        print r.read
      end
    end

    def read_rewind_read
      DATAWriter.file("r+") do |r|
        r.read
        r.rewind
        print r.read
      end
    end

    def append(string)
      DATAWriter.file("a+") do |a|
        a.write(string)
      end
    end

    def reset_data
      DATAWriter.file("w+") do |f|
        f.puts("epic data")
        f.print("\n")
        f.puts("A horse walks in to a bar. The bartender asks, 'why the long face'?")
      end
    end

    def read_with_DATA
      print DATA.read
    end

    def write_rplus(string)
      DATAWriter.file("r+") do |f|
        f.write(string)
      end
    end
  end
end

TestHelper.send(*ARGV)

__END__
epic data

A horse walks in to a bar. The bartender asks, 'why the long face'?
