require "areilayout/version"
require "thor"
require "rubygems"
require "active_record"
require "optparse"
require "open-uri"

module Areilayout

  class Config < Thor
    #default_command :set
    
    desc "", ""
    def set(source_path, layout_name)
      begin
        raise "Option is missing." if source_path.blank? || layout_name.blank?
        
        raise "Directory is not exist." unless Dir.exist?(source_path)
        
        init(source_path, layout_name)
        
        establish_database
        
        copy && setup
        true
        
      rescue => e
        p_error(e.message)
      end
    end

    desc "", ""
    def get(source_path, layout_name)
      begin
        raise "Option is missing." if source_path.blank? || layout_name.blank?

        init(source_path, layout_name)
          
        establish_database
        
        dl && copy && setup
        true

      rescue => e
        p_error(e.message)
      end
    end
    
private
    def init(source_path, layout_name)
      @source_path = source_path
      @layout_name = layout_name
      @app_root = Dir.getwd #=> RAILS_ROOT
      @dest_path = "#{@app_root}/sites/00/00/00/01/00000001/public/_themes/#{@layout_name}"
    end
    
    def dl
      require "zip"
      require "tempfile"
      
      filename = "#{Dir.tmpdir}/#{File.basename(@source_path)}"
      unless File.exist?(filename)
        open(filename, 'wb') do |file|
          open(URI.parse(@source_path)) do |data|
            file.write(data.read)
          end
        end
      end
      
      Zip::File.open(filename) do |zip|
        zip.each do |entry|
          #puts "entry #{entry.to_s}"
          #zip.extract(entry, "#{dest_path}/#{entry.to_s}") { true }
          zip.extract(entry, "#{Dir.tmpdir}/#{@layout_name}/#{entry.to_s}") { true }
        end
      end
      
      Dir.chdir "#{Dir.tmpdir}/#{@layout_name}"
      index_file = Dir.glob("**/index.html")
      @source_path = File.dirname(File.expand_path(index_file[0]))
    end
    
    def copy
      raise "index.html is not exist." unless File.exist?("#{@source_path}/index.html")
      FileUtils.mkdir_p(@dest_path) and p_info("mkdir #{@dest_path}") unless Dir.exist?(@dest_path)
      FileUtils.copy_entry(@source_path, @dest_path, {:verbose => true})
    end
    
    def setup
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
        head.gsub!("=\"#{dirname}/", "=\"/_themes/#{@layout_name}/#{dirname}/")
        body.gsub!("=\"#{dirname}/", "=\"/_themes/#{@layout_name}/#{dirname}/")
      end
      create_layout(head, body)
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
    
    def establish_database
      require "yaml"
      config = YAML.load_file("#{@app_root}/config/database.yml")
      ActiveRecord::Base.establish_connection(config["production"])
    end
    
    def p_error(msg)
      puts "ERROR: #{msg}"
      false and return
    end
    
    def p_info(msg)
      puts "INFO: #{msg}"
    end
    
  end

  require 'areilayout/layout'
end
