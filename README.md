data-writer
===========

Normally you can only read from DATA but with data-writer you can also write to it. This allows you to easily persist data in a source file.

__Installation__

gem install data-writer

__Usage__

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

__API__
