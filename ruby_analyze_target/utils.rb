#iqn_name or eui_name would be a MatchData, but target_name would be a string.
#iqn_name= nil
#eui_name= nil
#target_name = nil
#initiator_name =  nil

#class ACL_group is the acls group under a iSCSI entry
class ACL_group
  @initiator_rules_hash_list = nil
  @up_level_TPG = nil
  def initialize()
    #puts "initialized a acls group"
    @initiator_rules_hash_list = Hash.new
  end
  def store_rule(name)
    @initiator_rules_hash_list.store(name, ACL_rule.new(name))
  end
  def fetch_rule(name)	
    @initiator_rules_hash_list.fetch(name)
  end
end

#class ACL_rule is the acl rule for a specific initaitor
class ACL_rule
  @initiator_name = nil
  @userid = nil
  @password = nil
  @mutual_userid = nil
  @multual_password = nil
  @mapped_luns_hash_list = nil
  def initialize(name)
    @initiator_name =name
    @mapped_luns_hash_list = Hash.new
  end
  def store_userid(id)
    @userid = id
  end
  def fetch_userid()
    @userid
  end
  def store_password(password)
    @password = password
  end
  def fetch_password()
    @password
  end
  def store_mutual_userid(id)
    @mutual_userid = id
  end
  def fetch_mutual_userid()
    @mutual_userid
  end
  def store_mutual_password(password)
    @mutual_password = password
  end
  def fetch_mutual_password()
    @mutual_password
  end
  def store_mapped_lun(mapping_lun_number)
    @mapped_luns_hash_list.store(mapping_lun_number, Mapped_LUN.new(mapping_lun_number))
  end
  def fetch_mapped_lun(mapping_lun_number)
     @mapped_luns_hash_list.fetch(mapping_lun_number)
  end 
end

class Mapped_LUN
  @mapping_lun_number = nil
  @mapped_lun_number = nil

  def initialize(mapping_lun_num)
    @mapping_lun_number = mapping_lun_num
  end
  
  def store_mapping_lun_number(num)
    @mapping_lun_number = num
  end
  def store_mapped_lun_number(num)
    @mapped_lun_number = num
  end
  def fetch_mapping_lun_number()
    @mapping_lun_number
  end
  def fetch_mapped_lun_number()
    @mapped_lun_number
  end
end

class TPG
  @tpg_number = nil
  @acls_hash_list = nil
  @up_level_target = nil
  def initialize(number)
    #printf("Create a TPG with number %d.\n",number)
    @tpg_number = number
    @acls_hash_list = Hash.new 
  end
  def fetch_tpg_number()
    @tpg_number
  end
  #for now, we only have one acl group in a tpg, called "acls", so we only have one key-value pair
  #in the hash. The key is fixed "acls" in store and fetch. We have a paremeter acls_name 
  #in store_acl() and fetch_acl() for further update. 
  def store_acls(acls_name)
    @acls_hash_list.store("acls", ACL_group.new())
  end
  def fetch_acls(acls_name)
     @acls_hash_list.fetch("acls")
  end 
end

class Target
  @target_name=nil
  @tpg_hash_list=nil
  @luns={}
  def initialize(name)
    #printf("Initializing a target, name is %s.\n",name)
    @target_name = name
    @tpg_hash_list = Hash.new
  end
  def store_tpg(tpg_number)
    @tpg_hash_list.store(tpg_number, TPG.new(tpg_number))
  end
  def fetch_tpg(tpg_number)
     @tpg_hash_list.fetch(tpg_number)
  end
  def fetch_target_name()
    @target_name
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