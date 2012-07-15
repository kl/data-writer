data-writer
===========

Normally you can only read from DATA but with data-writer you can also write to it. This allows you to easily persist data in a source file.

###Installation

gem install data-writer

###Usage

Here is a simple example program that keeps track of how many times it has been executed and stores this as a YAML file in DATA.

```ruby
require 'data-writer'
require 'yaml'

store = YAML.load(DATA.read)
puts "run = #{store['run']}"
store["run"] += 1

DATAWriter.file("w+") do |w|
  w.write(store.to_yaml)
end

__END__
---
run: 1
```

Each time this program is run it will increment run by 1 and persist the result in the YAML hash.

###API

__DATAWriter.file(mode_string, opt = {})__

A factory method that makes file objects which can write to data.
mode_string and opt are the same as for File.new.
If this method is called with a block it behaves as File.open and if it is called without
a block it returns a File object as in File.new.

Example:

```ruby
# append to DATA
require 'data-writer'

appender = DATAWriter.file("a")
appender.write " my dear Watson"
appender.close  # DATA.read => "Elementary my dear Watson"

__END__
Elementary
```

If this method is called and DATA is not defined then it will raise a DATANotFoundError exception.
The file objects returned by this method have their #rewind method changed so that it seeks back to
the start of DATA, and not back to the start of the file.















