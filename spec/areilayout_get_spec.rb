require 'spec_helper'

describe Areilayout do

  before do
    @src_path     = "http://download.html5xcss3.com/fanktlk/templatesmonster/webstudio.zip"
    @layout_name  = "webstudio"
    @dest_dir = "/var/share/zomeki/sites/00/00/00/01/00000001/public/_themes"
    Dir.chdir("/var/share/zomeki")
  end
  
  it 'has error if index.html is not exist in templates' do
    @src_path     = "http://download.html5xcss3.com/fanktlk/templatesmonster/petclinic.zip"
    @layout_name  = "petclinic"
      
    @ret = Areilayout::Config.new.get(@src_path, @layout_name)
    expect(@ret).to eq false
  end
  
  it 'is successfully get template & setup layout' do
    @ret = Areilayout::Config.new.get(@src_path, @layout_name)
    expect(@ret).to eq true
    
    filename = "#{Dir.tmpdir}/#{File.basename(@src_path)}"
    expect(File.exist?(filename)).to eq true
    
    #Dir.chdir "#{Dir.tmpdir}/#{@layout_name}"
    #index_file = Dir.glob("**/index.html")
    #expect(File.exist?(File.expand_path(index_file[0]))).to eq true
    expect(File.exist?("#{Dir.tmpdir}/#{@layout_name}")).to eq false
    
  end
end
