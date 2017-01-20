require './utils.rb'

re_iqn_target = Regexp.new(/iqn\.\d{4}\-\d{2}\.[\w\.:\-]+\s\.+\s\[TPGs:\s\d+\]/)
re_iqn_name = Regexp.new(/iqn\.\d{4}-\d{2}\.[\w\.:\-]+/)

re_eui_target = Regexp.new(/eui\.\w+\s\.+\s\[TPGs:\s\d+\]/)
re_eui_name = Regexp.new(/eui\.\w+/)

re_tpg = Regexp.new(/tpg\d+\s/)

re_acls_group = Regexp.new(/acls\s\.+\s\[ACLs\:\s\d+\]/)

re_acl_iqn_rule = Regexp.new(/iqn\.\d{4}\-\d{2}\.[\w\.:\-]+\s\.+\s\[[\w\-\s\,]*Mapped\sLUNs\:\s\d+\]/)
re_acl_eui_rule = Regexp.new(/eui\.\w+\s\.+\s\[[\w\-\s\,]*Mapped\sLUNs\:\s\d+\]/)

#iqn_name or eui_name would be a MatchData, but target_name would be a string.
iqn_name= nil
eui_name= nil
target_name = nil
initiator_name =  nil

#tgp_name would be a MatchData, but tgp_num should be a string.
tpg_name = nil
tpg_num = nil

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


file = File.open("target.txt","r")
#str = File.readlines(file)    #This is an array
#TODO: Need to add some error handling code here, like failed to start the service.
str = `targetcli ls`.split("\n") #This is an arrry now, so that we can analyze the lines one by one

targets_list = TargetList.new

#The function handles a rule for one specific initiator
#def handle_acl_rule(match)
  #initiator_name = match.to_s
  #puts initiator_name	
  #current_acls_group.store_rule(initiator_name)
  #current_acl_rule = $current_acls_group.fetch_rule(initiator_name)
#end

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

#handle ACLs group here
  if re_acls_group.match(line)
     puts line
     current_tpg.store_acls("acls")
     current_acls_group = current_tpg.fetch_acls("acls")
  end
  
#handle acl rules here
  if match = re_acl_iqn_rule.match(line) || match = re_acl_eui_rule.match(line)
    puts line
    #handle_acl_rule(match)
    initiator_name = match.to_s
    puts initiator_name	
    current_acls_group.store_rule(initiator_name)
    current_acl_rule = current_acls_group.fetch_rule(initiator_name)
  end
  
  #get authentication information: userid, password, mutual_userid and mutual_password here.
  #puts "targetcli get auth #{current_target}"
  
end

#targets_list.print()
