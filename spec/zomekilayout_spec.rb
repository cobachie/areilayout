require 'spec_helper'

describe Zomekilayout do

  before do
    @src_path     = "/var/share/html/bootstrap-3.1.1-dist"
    @layout_name  = "bootstrap"
    @dest_dir = "/var/share/zomeki/sites/00/00/00/01/00000001/public/_themes"
    Dir.chdir("/var/share/zomeki")
  end
  
  it 'has a version number' do
    expect(Zomekilayout::VERSION).not_to be nil
  end
  
  #it 'has error if invalid optoion' do
  #  #@ret = Zomekilayout::Config.new.set({a: "#{@src_path}", b: "#{@layout_name}"})
  #  @ret = Zomekilayout::Config.new.set(@src_path, @layout_name)
  #  expect(@ret).to eq false
  #end
  
  it 'has error if option is misshing' do
    #@ret = Zomekilayout::Config.new.set({a: nil, b: nil})
    @ret = Zomekilayout::Config.new.set(nil, nil)
    expect(@ret).to eq false
  end
  
  it 'has error if source directory is not exist' do
    #@ret = Zomekilayout::Config.new.set({p: "/var/share/html/test", n: "#{@layout_name}"})
    @ret = Zomekilayout::Config.new.set("/var/share/html/test", @layout_name)
    expect(@ret).to eq false
  end
  
  it 'has error if current directory is not RAILS_ROOT' do
    Dir.chdir("/var/share/zomeki/tmp")
    #@ret = Zomekilayout::Config.new.set({p: "#{@src_path}", n: "#{@layout_name}"})
    @ret = Zomekilayout::Config.new.set(@src_path, @layout_name)
    expect(@ret).to eq false
  end
  
  it 'has error if index.html is not exist under destination path' do
    #@ret = Zomekilayout::Config.new.set({p: "/var/share/html/vintage/", n: "#{@layout_name}"})
    dest_path = "#{@dest_dir}/#{@layout_name}"
    FileUtils.remove_dir(dest_path) if Dir.exist?(dest_path)
    @ret = Zomekilayout::Config.new.set("/var/share/html/vintage/", @layout_name)
    expect(@ret).to eq false
  end
  
  it 'is successfully setup layout' do
    #@ret = Zomekilayout::Config.new.set({p: "#{@src_path}", n: "#{@layout_name}"})
    @ret = Zomekilayout::Config.new.set(@src_path, @layout_name)
    expect(@ret).to eq true
  end

end
