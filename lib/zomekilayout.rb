require "zomekilayout/version"
require "thor"
require "rubygems"
require "active_record"
require "optparse"

module Zomekilayout

  class Config < Thor
  
    desc "", ""
    def set( args = {} )
      begin
      
        raise "Option is missing." if args[:p].blank? || args[:n].blank?

        raise "Directory is not exist." unless Dir.exist?(args[:p])
        
        @source_path = args[:p]
        @layout_name = args[:n]
        @app_root = Dir.getwd #=> "/var/share/zomeki"
        @dest_path = "#{@app_root}/sites/00/00/00/01/00000001/public/_themes/#{@layout_name}"
        
        establish_database
        
        copy
        
        setup

      rescue => e
        p_error(e.message)
      end
    end
    
    desc "", ""
    def opts(args)
      opt = OptionParser.new
      opt.on('-p') {|v| args[:p] = v }
      opt.on('-n') {|v| args[:n] = v }
      opt.parse(args)
    end
    
    private
    def copy
      
      FileUtils.mkdir_p(@dest_path) and p_info("mkdir #{@dest_path}") unless Dir.exist?(@dest_path)
      
      FileUtils.copy_entry(@source_path, @dest_path, {:verbose => true})

    end
    
    def setup
      raise "[index.html] is not exist." unless File.exist?("#{@dest_path}/index.html")
      
      contents = Pathname("#{@dest_path}/index.html").read(:encoding => Encoding::UTF_8)
      head = contents.slice((contents.index("<head>") + 6)..(contents.index("</head>") - 1))
      body = contents.slice((contents.index("<body>") + 6)..(contents.index("</body>") - 1))
      
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
      puts @layout.inspect
    end
    
    def update_node
      @node = Node.find(2)
      @node.layout_id = @layout.id
      @node.save!
      puts @node.inspect
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
