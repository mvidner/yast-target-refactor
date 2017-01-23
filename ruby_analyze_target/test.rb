require './utils.rb'

re_iqn_target = Regexp.new(/iqn\.\d{4}\-\d{2}\.[\w\.:\-]+\s\.+\s\[TPGs:\s\d+\]/)
re_iqn_name = Regexp.new(/iqn\.\d{4}-\d{2}\.[\w\.:\-]+/)

re_eui_target = Regexp.new(/eui\.\w+\s\.+\s\[TPGs:\s\d+\]/)
re_eui_name = Regexp.new(/eui\.\w+/)

re_tpg = Regexp.new(/tpg\d+\s/)

re_acls_group = Regexp.new(/acls\s\.+\s\[ACLs\:\s\d+\]/)

re_acl_iqn_rule = Regexp.new(/iqn\.\d{4}\-\d{2}\.[\w\.:\-]+\s\.+\s\[[\w\-\s\,]*Mapped\sLUNs\:\s\d+\]/)
re_acl_eui_rule = Regexp.new(/eui\.\w+\s\.+\s\[[\w\-\s\,]*Mapped\sLUNs\:\s\d+\]/)

#match a line like this:
#mapped_lun1 .......................................................................... [lun2 fileio/iscsi_file1 (rw)]
re_mapped_lun_line = Regexp.new(/mapped_lun\d+\s\.+\s\[lun\d+\s/)

# match the mapped lun like "mapped_lun1", we matched one more \s here to aovid bugs in configfs / targetcli mismatch, need to strip when use
re_mapping_lun = Regexp.new(/mapped_lun\d+\s/)

#match the mapped lun, like "[lun2" in "[lun2 fileio/iscsi_file1 (rw)]", we matched one more \s to avoid bugs.
re_mapped_lun = Regexp.new(/\[lun\d+\s/)

#iqn_name or eui_name would be a MatchData, but target_name would be a string.
iqn_name= nil
eui_name= nil
target_name = nil
initiator_name =  nil

#tgp_name would be a MatchData, but tgp_num should be a string.
tpg_name = nil
tpg_num = nil

#the string for a mapping lun, like mapped_lun1
mapping_lun_name = nil
#the string for a mapped lun, like "lun2" in "[lun2 fileio/iscsi_file1 (rw)]"
mapped_lun_name = nil

#will store anything match our regexp
match = nil

# A pointer points to the target in the list that we are handling.
current_target = nil
# A pointer points to the tpg in the target that we are handling.
current_tpg = nil
# A pointer points to the acls group
current_acls_group = nil
#A pointer points to the acl rule for a specific initiator we are handling
current_acl_rule = nil

# the command need to execute  and the result
cmd = nil
cmd_out = nil


#TODO: Need to add some error handling code here, like failed to start the service.
str = `targetcli ls`.split("\n") #This is an arrry now, so that we can analyze the lines one by one

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

#handle ACLs group here
  if re_acls_group.match(line)
     #puts line
     current_tpg.store_acls("acls")
     current_acls_group = current_tpg.fetch_acls("acls")
  end
  
#handle acl rules for an IQN initaitor here
  if re_acl_iqn_rule.match(line)
    #puts line
    #handle_acl_rule(match)
    initiator_name = re_iqn_name.match(line).to_s
    #puts initiator_name	
    current_acls_group.store_rule(initiator_name)
    current_acl_rule = current_acls_group.fetch_rule(initiator_name)
    #get authentication information here.
    #get userid
    cmd = "targetcli iscsi/" + current_target.fetch_target_name() + "/tpg" + current_tpg.fetch_tpg_number() + "/acls/" + initiator_name + "/ get auth userid"
    cmd_out = `#{cmd}`
    current_acl_rule.store_userid(cmd_out[7 , cmd.length])
   # puts current_acl_rule.fetch_userid()
    #get password
    cmd = "targetcli iscsi/" + current_target.fetch_target_name() + "/tpg" + current_tpg.fetch_tpg_number() + "/acls/" + initiator_name + "/ get auth password"
    cmd_out = `#{cmd}`
    current_acl_rule.store_password(cmd_out[9 , cmd.length])
   # puts current_acl_rule.fetch_password()
    #get mutual_userid
    cmd = "targetcli iscsi/" + current_target.fetch_target_name() + "/tpg" + current_tpg.fetch_tpg_number() + "/acls/" + initiator_name + "/ get auth mutual_userid"
    cmd_out = `#{cmd}`
    current_acl_rule.store_mutual_userid(cmd_out[14 , cmd.length])
    #puts current_acl_rule.fetch_mutual_userid()
    #get mutual_password
    cmd = "targetcli iscsi/" + current_target.fetch_target_name() + "/tpg" + current_tpg.fetch_tpg_number() + "/acls/" + initiator_name + "/ get auth mutual_password"
    cmd_out = `#{cmd}`
    current_acl_rule.store_mutual_password(cmd_out[16 , cmd.length])
    #puts current_acl_rule.fetch_mutual_password()
  end
  
  #handle acl rules for an EUI initaitor here
  if re_acl_eui_rule.match(line)
    #puts line
    #handle_acl_rule(match)
    initiator_name = re_eui_name.match(line).to_s
    #puts initiator_name	
    current_acls_group.store_rule(initiator_name)
    current_acl_rule = current_acls_group.fetch_rule(initiator_name)
    #get authentication information here.
    #get userid
    cmd = "targetcli iscsi/" + current_target.fetch_target_name() + "/tpg" + current_tpg.fetch_tpg_number() + "/acls/" + initiator_name + "/ get auth userid"
    cmd_out = `#{cmd}`
    current_acl_rule.store_userid(cmd_out[7 , cmd.length])
    #puts current_acl_rule.fetch_userid()
    #get password
    cmd = "targetcli iscsi/" + current_target.fetch_target_name() + "/tpg" + current_tpg.fetch_tpg_number() + "/acls/" + initiator_name + "/ get auth password"
    cmd_out = `#{cmd}`
    current_acl_rule.store_password(cmd_out[9 , cmd.length])
  #  puts current_acl_rule.fetch_password()
    #get mutual_userid
    cmd = "targetcli iscsi/" + current_target.fetch_target_name() + "/tpg" + current_tpg.fetch_tpg_number() + "/acls/" + initiator_name + "/ get auth mutual_userid"
    cmd_out = `#{cmd}`
    current_acl_rule.store_mutual_userid(cmd_out[14 , cmd.length])
    #puts current_acl_rule.fetch_mutual_userid()
    #get mutual_password
    cmd = "targetcli iscsi/" + current_target.fetch_target_name() + "/tpg" + current_tpg.fetch_tpg_number() + "/acls/" + initiator_name + "/ get auth mutual_password"
    cmd_out = `#{cmd}`
    current_acl_rule.store_mutual_password(cmd_out[16 , cmd.length])
    #puts current_acl_rule.fetch_mutual_password()
  end

  #handle mapped luns here
  if re_mapped_lun_line.match(line)
    puts line
    mapping_lun_name = re_mapping_lun.match(line).to_s.strip
    puts mapping_lun_name
    mapped_lun_name = re_mapped_lun.match(line).to_s.strip
    mapped_lun_name.slice!("[")
    puts mapped_lun_name
    mapping_lun_num = mapping_lun_name[10,mapping_lun_name.length]
    current_acl_rule.store_mapped_lun(mapping_lun_num)
    mapped_lun_num = mapped_lun_name[3,mapped_lun_name.length]
    current_acl_rule.fetch_mapped_lun(mapping_lun_num).store_mapped_lun_number(mapped_lun_num)
  end
  
end
targets_list.print()
