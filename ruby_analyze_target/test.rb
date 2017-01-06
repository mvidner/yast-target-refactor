class Acl
  @initiator_name=nil
  @mapped_luns={}
  @userid=nil
  @password=nil
  @mutual_userid=nil
  @multual_password=nil
end

class Tgp
  @tpg_number=nil
  @acls=[]
end

class Target
  @targetName=nil
  @tgp={}
  @luns={}
  def initialize(name)
    printf("Initializing a target, name is %s.\n",name)
    @targetName = name
  end
end

class TargetList
  @target_list = nil
  def print()
    @target_list.each do |key,value|
     p value
    end
  end
  def initialize()
    @target_list = Hash.new
  end
  def store_target(target_name)
    @target_list.store(target_name,Target.new(target_name))
  end

end

file = File.open("target.txt","r")
str = File.readlines(file)    #This is an array

re_iqn_target = Regexp.new(/iqn\.\d{4}\-\d{2}\.[\w\.:\-]+\s\.+\s\[TPGs:\s\d+\]/)
re_iqn_name = Regexp.new(/iqn\.\d{4}-\d{2}\.[\w\.:\-]+/)
re_eui_target = Regexp.new(/eui\.\w+\s\.+\s\[TPGs:\s\d+\]/)
re_eui_name = Regexp.new(/eui\.\w+/)

iqn_name= nil
eui_name= nil
targets_list = TargetList.new

str.each do |line|
  if re_iqn_target.match(line)
    #puts line
    if iqn_name = re_iqn_name.match(line)
     # puts iqn_name
	    targets_list.store_target(iqn_name.to_s)
    end
  end
  
  if re_eui_target.match(line)
    #puts line
    if eui_name = re_eui_name.match(line)
     # puts eui_name
      targets_list.store_target(eui_name.to_s)
    end
  end
end

targets_list.print()
