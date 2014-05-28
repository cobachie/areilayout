module Areilayout
  
  class Utils
  
    def self.p_error(msg)
      puts "ERROR: #{msg}"
      false and return
    end
    
    def self.p_info(msg)
      puts "INFO: #{msg}"
    end
    
    def self.rmdir(layout_name)
      FileUtils.remove_entry("#{Dir.tmpdir}/#{layout_name}")
    end
    
    def self.tagclip(contents, tag)
      /<#{tag}.*>((\n|.)*)<\/#{tag}>/ =~ contents
      return [$&, $1]
    end
    
  end
  
end
