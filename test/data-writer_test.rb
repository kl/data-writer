#encoding: utf-8

require 'minitest/spec'
require 'minitest/autorun'

def h
  Dir.getwd.include?('test') ? 'ruby test_helper.rb' : 'ruby test/test_helper.rb'
end

describe "DATAWriter" do

  it "can read what comes after __END__" do
    result = `#{h} read`
    result.must_equal "epic data\n\nA horse walks in to a bar. The bartender asks, 'why the long face'?\n"
  end

  it "must return the same as DATA.read" do
    result = `#{h} read`
    data   = `#{h} read_with_DATA`
    result.must_equal data
  end

  it "can write stuff after __END__" do
    `#{h} write "The brown fox jumps over the yellow snail."`
    result = `#{h} read`
    `#{h} reset_data`
    result.must_equal "The brown fox jumps over the yellow snail."
  end

  it "can open a file using File::Constants" do
    `#{h} int_mode_write "1337"`
    result = `#{h} read`
    `#{h} reset_data`
    result.must_equal "1337"
  end

  it "can rewind back to __END__" do
    result = `#{h} read_rewind_read`
    result.must_equal "epic data\n\nA horse walks in to a bar. The bartender asks, 'why the long face'?\n"
  end

  it "can append to the end of the file" do
    `#{h} append "no more epic data"`
    result = `#{h} read`
    `#{h} reset_data`
    result.must_equal "epic data\n\nA horse walks in to a bar. The bartender asks, 'why the long face'?\nno more epic data"
  end

  it "can write to the beginning of DATA" do
    `#{h} write_rplus "TEST DATA"`
    result = `#{h} read`
    `#{h} reset_data`
    result.must_equal "TEST DATA\n\nA horse walks in to a bar. The bartender asks, 'why the long face'?\n"
  end

  it "must create a file with the same encoding as the source encoding" do
    skip("Encoding not supported") unless Module.const_defined?(:Encoding)

    `#{h} write_utf8_test`

    helper_path = h.sub("ruby ", "")
    text = File.read(helper_path).force_encoding("UTF-8")   # because we know that the encoding in the helper file is UTF-8
    data = text[/__END__\s*(.+)/m, 1]

    data.valid_encoding?.must_equal true
    data.must_equal "ちょうどいい"

    `#{h} reset_data`
  end
end
