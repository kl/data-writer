
class DATAWriter

  class DATANotFoundError < StandardError; end

  #
  # The position in the file where DATA starts (line after __END__)
  #
  def self.data_start_pos
    @data_start_pos
  end
  
  #
  # Factory method for DATA writers. Works simliar to File.new.
  #
  def self.file(mode, opt={})
    check_DATA_defined  # raises an exception if DATA is not defined.

    if mode =~ /w/      # if we have a "w" we first need to delete everything after __END__.
      clear_end
      mode.include?("b") ? m = "rb+" : m = "r+"   # the actual mode will be rb+ or r+.
      file = File.new(DATA, m, opt)
    else
      file = File.new(DATA, mode, opt)
    end

    @data_start_pos = scan_data_pos   # remeber the current position of __END__.
    file.pos = @data_start_pos        # sets the file pos to the line after __END__.
    enhanced = enhance_file(file)     # adds specialized methods for this object.

    if block_given?
      yield(enhanced)
      enhanced.close
    else
      enhanced
    end
  end

  #
  # Deletes everything after __END__. This is used to simulate the "w" permission mode.
  #
  def self.clear_end
    file_path = File.expand_path($0)
    file_content = File.read(file_path)
    new_content = file_content[/.+?^__END__$/m] + "\n"    # everything up to an including __END__.

    File.open(file_path, "w") { |f| f.write(new_content) }
  end
  private_class_method :clear_end

  #
  # Finds the position in the file after __END__. DATA.pos isn't used because of
  # problems when opening the file in "w" mode.
  #
  def self.scan_data_pos
    source_file = File.new(File.expand_path($0))

    until source_file.eof?
      line = source_file.gets
      if line =~ /^^__END__$/
        pos = source_file.pos
        source_file.close
        return pos
      end
    end
    source_file.close
    raise DATANotFoundError, "DATA object does not exist. Ensure that the file has __END__"
  end
  private_class_method :scan_data_pos

  #
  # Adds specialized methods to the DATA writer object.
  #
  def self.enhance_file(object)

    def object.rewind   # so that #rewind will go back to __END__ and not the beginning of the file.
      self.pos = DATAWriter.data_start_pos
    end

    object
  end
  private_class_method :enhance_file

  #
  # Raises a DATANotFoundError exception if DATA is not defined.
  #
  def self.check_DATA_defined
    begin
      DATA
    rescue NameError
      raise DATANotFoundError, "DATA object does not exist. Ensure that the file has __END__"
    end
  end
  private_class_method :check_DATA_defined
end
