require "zomekilayout/version"
require "thor"
require "yaml"

require "rubygems"
require "active_record"

module Zomekilayout
  class Design < Thor
    desc "design_type", "sample"
    #def self.register(design_type, src_dir, dest_dir)
    def register(design_type)
      src_dir ||= File.expand_path("../../templates", __FILE__)
      app_root = "/var/share/zomeki"
      dest_dir ||= "#{app_root}/sites/00/00/00/01/00000001/public/_themes"
      
      # establish database connection
      config = YAML.load_file("#{app_root}/config/database.yml")
      ActiveRecord::Base.establish_connection(config["production"])
      
      design_type ||= 'bootstrap'
      if design_type == 'bootstrap'
        bootstrap = Zomekilayout::Bootstrap.new
        bootstrap.copy(src_dir, dest_dir)
        bootstrap.setup
      end
    end

  end
  
  class Layout < ActiveRecord::Base
    self.table_name = 'cms_layouts'
  end
  
  class Node < ActiveRecord::Base
    self.table_name = 'cms_nodes'
  end
  
  class Bootstrap
  
    def copy(src_dir, dest_dir)      
      Dir.mkdir(dest_dir) unless Dir.exist?(dest_dir)

      filenames = Dir.glob("#{src_dir}/bootstrap-3.1.1-dist/*")
      filenames.each do |filename|
        if File.directory?(filename)
          dirname = filename.split("/").last 
          Dir.mkdir("#{dest_dir}/#{dirname}") unless Dir.exist?("#{dest_dir}/#{dirname}")
        end
        FileUtils.copy_entry(filename, "#{dest_dir}/#{dirname}", {:verbose => true})
      end
      puts "---> Successfully copied files under #{dest_dir}."
    end
    
    def setup
      pathname = Pathname.new(File.expand_path("../zomekilayout/bootstrap", __FILE__))
      head = Pathname("#{pathname}/head.html.erb").read(:encoding => Encoding::UTF_8)
      body = Pathname("#{pathname}/body.html.erb").read(:encoding => Encoding::UTF_8)

      @layout = Layout.new
      @layout.concept_id = 1
      @layout.site_id = 1
      @layout.state = "public"
      @layout.name = "default"
      @layout.title = "default"
      @layout.head = "#{head}"
      @layout.body = "#{body}"    
#      @layout.in_creator = {'group_id' => 2, 'user_id' => 1}
      @layout.save!
      puts "---> Successfully create to cms_layouts"
      
      @node = Node.find(2)
      @node.layout_id = @layout.id
      @node.save!
      puts "---> Successfully update to cms_nodes"
    end
  end
  
end
