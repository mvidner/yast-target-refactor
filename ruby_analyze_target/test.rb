#class ACL is the acls group
class ACL
  rules_hash_list = nil
  def initialize()
    rules_hash_list = Hash.new
  end
end

#class ACL_rule is the acl rule for a specific initaitor
class ACL_rule
  @initiator_name = nil
  @mapped_luns = nil
  @userid = nil
  @password = nil
  @mutual_userid = nil
  @multual_password = nil
end

class TPG
  @tpg_number = nil
  @acls_hash_list = nil
  def initialize(number)
    #printf("Create a TPG with number %d.\n",number)
    @tpg_number = number
    @acls_hash_list = Hash.new 
  end
  #for now, we only have one acl group in a tpg, called "acls", so we only have one key-value pair
  #in the hash. The key is fixed "acls" in store and fetch. We have a paremeter acls_name 
  #in store_acl() and fetch_acl() for further update. 
  def store_acls(acls_name)
    @acls_hash_list.store("acls", ACL.new())
  end
  def fetch_acls(acls_name)
     @acls_hash_list.fetch("acls")
  end 
end

class Target
  @targetName=nil
  @tpg_hash_list=nil
  @luns={}
  def initialize(name)
    #printf("Initializing a target, name is %s.\n",name)
    @targetName = name
    @tpg_hash_list = Hash.new
  end
  def store_tpg(tpg_number)
    @tpg_hash_list.store(tpg_number, TPG.new(tpg_number))
  end
  def fetch_tpg(tpg_number)
     @tpg_hash_list.fetch(tpg_number)
  end
end

class TargetList
  @target_hash_list = nil
  def print()
    @target_hash_list.each do |key, value|
     p value
    end
  end
  def initialize()
    @target_hash_list = Hash.new
  end
  def store_target(target_name)
    @target_hash_list.store(target_name, Target.new(target_name))
  end
  def fetch_target(target_name)
     @target_hash_list.fetch(target_name)
  end

end

file = File.open("target.txt","r")
str = File.readlines(file)    #This is an array

re_iqn_target = Regexp.new(/iqn\.\d{4}\-\d{2}\.[\w\.:\-]+\s\.+\s\[TPGs:\s\d+\]/)
re_iqn_name = Regexp.new(/iqn\.\d{4}-\d{2}\.[\w\.:\-]+/)
re_eui_target = Regexp.new(/eui\.\w+\s\.+\s\[TPGs:\s\d+\]/)
re_eui_name = Regexp.new(/eui\.\w+/)
re_tpg = Regexp.new(/tpg\d+\s/)
re_acls = Regexp.new(/acls\s\.+\s\[ACLs\:\s\d+\]/)
re_acl_iqn = Regexp.new(/iqn\.\d{4}\-\d{2}\.[\w\.:\-]+\s\.+\s\[[\w\-\s\,]*Mapped\sLUNs\:\s\d+\]/)

#iqn_name or eui_name would be a MatchData, but target_name would be a string.
iqn_name= nil
eui_name= nil
target_name = nil
#tgp_name would be a MatchData, but tgp_num should be a string.
tpg_name = nil
tpg_num = nil

# A pointer points to the target in the list that we are handling.
current_target = nil
# A pointer points to the tpg in the target that we are handling.
current_tpg = nil
# A pointer points to the acls group
current_acls = nil

targets_list = TargetList.new

str.each do |line|
  #handle iqn targets here.
  if re_iqn_target.match(line)
    #puts line
    if iqn_name = re_iqn_name.match(line)  
     # puts iqn_name
      target_name=iqn_name.to_s
      targets_list.store_target(target_name)
      current_target = targets_list.fetch_target(target_name)
      #p current_target
    end    
  end

  #handle eui targets here.
  if re_eui_target.match(line)
    #puts line
    if eui_name = re_eui_name.match(line)
     # puts eui_name
      target_name=eui_name.to_s
      targets_list.store_target(target_name)
      current_target = targets_list.fetch_target(target_name)
      #p current_target
    end
  end

 #handle TPGs here.
  if tpg_name = re_tpg.match(line)
    #puts tpg_name.to_s.strip
    #find the tpg number
    tpg_num = /\d+/.match(tpg_name.to_s.strip)
    current_target.store_tpg(tpg_num.to_s.strip)
    current_tpg = current_target.fetch_tpg(tpg_num.to_s.strip)
  end

#handle ACLs here
  if re_acls.match(line)
     puts line
     current_tpg.store_acls("acls")
     current_acls = current_tpg.fetch_acls("acls")
  end
  #handle the rule for one specific initiator here
  if re_acl_iqn.match(line)
    puts line
    iqn_name = re_iqn_name.match(line).to_s
    puts iqn_name
  end
  
end

targets_list.print()
