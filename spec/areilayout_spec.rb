require 'spec_helper'

describe Areilayout do

  before do
    @src_path     = "/var/share/html/vintage/vintage_files/html"
    @layout_name  = "vintage"
    @dest_dir = "/var/share/zomeki/sites/00/00/00/01/00000001/public/_themes"
    Dir.chdir("/var/share/zomeki")
  end
  
  it 'has a version number' do
    expect(Areilayout::VERSION).not_to be nil
  end
  
  #it 'has error if invalid optoion' do
  #  #@ret = Areilayout::Config.new.set({a: "#{@src_path}", b: "#{@layout_name}"})
  #  @ret = Areilayout::Config.new.set(@src_path, @layout_name)
  #  expect(@ret).to eq false
  #end
  
  it 'has error if option is misshing' do
    #@ret = Areilayout::Config.new.set({a: nil, b: nil})
    @ret = Areilayout::Config.new.set(nil, nil)
    expect(@ret).to eq false
  end
  
  it 'has error if source directory is not exist' do
    #@ret = Areilayout::Config.new.set({p: "/var/share/html/test", n: "#{@layout_name}"})
    @ret = Areilayout::Config.new.set("/var/share/html/test", @layout_name)
    expect(@ret).to eq false
  end
  
  it 'has error if current directory is not RAILS_ROOT' do
    Dir.chdir("/var/share/zomeki/tmp")
    #@ret = Areilayout::Config.new.set({p: "#{@src_path}", n: "#{@layout_name}"})
    @ret = Areilayout::Config.new.set(@src_path, @layout_name)
    expect(@ret).to eq false
  end
  
  it 'has error if index.html is not exist under destination path' do
    #@ret = Areilayout::Config.new.set({p: "/var/share/html/vintage/", n: "#{@layout_name}"})
    dest_path = "#{@dest_dir}/#{@layout_name}"
    FileUtils.remove_dir(dest_path) if Dir.exist?(dest_path)
    @ret = Areilayout::Config.new.set("/var/share/html/vintage/", @layout_name)
    expect(@ret).to eq false
  end
  
  it 'is successfully setup layout' do
    #@ret = Areilayout::Config.new.set({p: "#{@src_path}", n: "#{@layout_name}"})
    @ret = Areilayout::Config.new.set(@src_path, @layout_name)
    expect(@ret).to eq true
  end
  
end
