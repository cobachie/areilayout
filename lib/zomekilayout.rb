require "zomekilayout/version"
require "thor"
require "rubygems"
require "active_record"
require "optparse"

module Zomekilayout

  class Config < Thor
  
    desc "", ""
    def set(source_path, layout_name)
      begin

        raise "Option is missing." if source_path.blank? || layout_name.blank?

        raise "Directory is not exist." unless Dir.exist?(source_path)
        
        @source_path = source_path
        @layout_name = layout_name
        @app_root = Dir.getwd #=> should be RAILS_ROOT
        @dest_path = "#{@app_root}/sites/00/00/00/01/00000001/public/_themes/#{@layout_name}"
        
        establish_database
        
        copy
        
        setup

      rescue => e
        p_error(e.message)
      end
    end
    
    private
    def copy

      FileUtils.mkdir_p(@dest_path) and p_info("mkdir #{@dest_path}") unless Dir.exist?(@dest_path)
      FileUtils.copy_entry(@source_path, @dest_path, {:verbose => true})

    end
    
    def setup
      raise "[index.html] is not exist." unless File.exist?("#{@dest_path}/index.html")

      contents = Pathname("#{@dest_path}/index.html").read(:encoding => Encoding::UTF_8)
      /<head>((\n|.)*)<\/head>/ =~ contents
      head = $1
      /<body.*>((\n|.)*)<\/body>/ =~ contents
      body = $1

      dir_list = []
      Dir.glob("#{@dest_path}/*").each do |filename|
        dir_list << filename.split("/").last if File.directory?(filename)
      end
      
      dir_list.each do |dirname|
        head.gsub!("=\"#{dirname}/", "=\"_themes/#{@layout_name}/#{dirname}/")
        body.gsub!("=\"#{dirname}/", "=\"_themes/#{@layout_name}/#{dirname}/")
      end
      
      create_layout(head, body)
      
      update_node
      
      true
    end
    
    def create_layout(head, body)
      @layout = Layout.new
      @layout.concept_id = 1
      @layout.site_id = 1
      @layout.state = "public"
      @layout.name = @layout_name
      @layout.title = @layout_name
      @layout.head = head
      @layout.body = body
#      @layout.in_creator = {'group_id' => 2, 'user_id' => 1}
      @layout.save!
    end
    
    def update_node
      @node = Node.find(2)
      @node.layout_id = @layout.id
      @node.save!
    end
    
    def p_usage
      puts <<-EOL
Usage: zomekilayout set [options]
  -p
  -n
      EOL
      false
    end
    
    def p_error(msg)
      puts "ERROR: #{msg}"
      false and return
    end
    
    def p_info(msg)
      puts "INFO: #{msg}"
    end
    
    def establish_database
      require "yaml"
      config = YAML.load_file("#{@app_root}/config/database.yml")
      ActiveRecord::Base.establish_connection(config["production"])
    end
    
  end
  
  class Layout < ActiveRecord::Base
    self.table_name = 'cms_layouts'
  end
  
  class Node < ActiveRecord::Base
    self.table_name = 'cms_nodes'
  end  
end
