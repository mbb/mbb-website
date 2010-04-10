# Paperclip fix (mangling original file names)
# From http://gist.github.com/313205
module Paperclip
  class Attachment
    alias_method :original_assign, :assign

    def assign uploaded_file
      original_assign uploaded_file
      instance_write :file_name, uploaded_file.original_filename.strip
    end
  end
end
