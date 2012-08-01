#encoding: utf-8

class DATAWriter

  class DATANotFoundError < StandardError; end

  #
  # Factory method for DATA writers. Works simliar to File.new.
  # mode can be both a string like "w" or a number like File::WRONLY
  #
  def self.file(mode, opt={})
    raise_data_not_found unless Object.const_defined?(:DATA)

    if mode.is_a?(String)
      valid_mode = get_valid_string_mode(mode)
    else
      valid_mode = get_valid_int_mode(mode)
    end

    file = create_file(get_source_path, valid_mode, opt)
    file.pos = DATA.pos                                     # sets the file pos to the line after __END__.
    enhanced = enhance_file(file)                           # adds specialized methods for this object.

    if block_given?
      yield(enhanced)
      enhanced.close
    else
      enhanced
    end
  end

  #
  # Get the path of the source file.
  #
  def self.get_source_path
    File.expand_path($0)
  end
  private_class_method :get_source_path

  #
  # If "w" was specifed as a mode we need to remove that (because it will truncate the whole file)
  # 
  def self.get_valid_string_mode(mode)
    if mode =~ /w/
      trunc_end                                       # truncate after __END__.
      sub_with = mode.include?("+") ? "r" : "r+"      # the actual mode will be "r+"
      mode.sub("w", sub_with)
    else
      mode
    end
  end
  private_class_method :get_valid_string_mode

  #
  # Same as get_valid_string_mode but for the integer modes specifed in File::Constants.
  #
  def self.get_valid_int_mode(mode)
    if (mode & File::TRUNC) == File::TRUNC        # mode includes TRUNC
      trunc_end                                   # truncate after __END__.
      valid_mode = 0
      File::Constants.constants.each do |const|   # build new mode excluding TRUNC
        value = File::const_get(const)
        next if value.is_a?(String)               # for example File::NULL
        if (mode & value) == value && value != File::TRUNC
          valid_mode |= value
        end
      end
      valid_mode
    else
      mode
    end
  end
  private_class_method :get_valid_int_mode

  #
  # Deletes everything after __END__. This is used to simulate the "w" permission mode.
  #
  def self.trunc_end
    file_content = File.read(get_source_path)
    new_content = file_content[/.+?^__END__$/m] + "\n"    # everything up to and including __END__.

    File.open(get_source_path, "w") { |f| f.write(new_content) }
  end
  private_class_method :trunc_end

  #
  # Helper method to create a file that works in both 1.8 and 1.9 and different implementations.
  #
  def self.create_file(path, mode_string, opt = {})
    ruby = RUBY_VERSION[/\d\.\d\.\d/]

    if RUBY_PLATFORM =~ /java/i
      if ruby >= "1.9.3"
        File.new(path, mode_string, opt_with_encoding(opt))   # Only JRuby 1.7 seem to implement this method the 1.9 way.
      else
        File.new(path, mode_string)
      end

    else
      if ruby >= "1.9.0"
        File.new(path, mode_string, opt_with_encoding(opt))
      else
        File.new(path, mode_string)
      end
    end
  end
  private_class_method :create_file

  #
<<<<<<< HEAD
  # Deletes everything after __END__. This is used to simulate the "w" permission mode.
  #
  def self.clear_end
    file_content = File.read(get_source_path)
    new_content = file_content[/.+?^__END__$/m] + "\n"    # everything up to an including __END__.

    File.open(get_source_path, "w") { |f| f.write(new_content) }
  end
  private_class_method :clear_end

=======
  # Returns a new options hash that has it's :encoding key set to the source file encoding.
>>>>>>> Refactoring
  #
  def self.opt_with_encoding(opt)
    {:encoding => __ENCODING__}.merge(opt)
  end
  private_class_method :opt_with_encoding

  #
  # Adds specialized methods to the DATA writer object.
  #
  def self.enhance_file(file)

    file.instance_variable_set(:@DATA_pos, file.pos)

    def file.rewind   # so that #rewind will go back to __END__ and not the beginning of the file.
      self.pos = @DATA_pos
    end

    file
  end
  private_class_method :enhance_file

  #
  # Raises a DATANotFoundError exception.
  #
  def self.raise_data_not_found
    raise DATANotFoundError, "DATA object does not exist. Ensure that the file has __END__"
  end
  private_class_method :raise_data_not_found
end
