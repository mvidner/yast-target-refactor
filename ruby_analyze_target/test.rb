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
  def initialize()
    printf("Initializing a target.\n")
  end
end

file = File.open("target.txt","r")
str = File.readlines(file)    #This is an array
#puts str
re_iqn_target = Regexp.new(/iqn\.\d{4}\-\d{2}\.[\w\.]+\s\.+\s\[TPGs:\s\d+\]/)
#re = Regexp.new(/iqn\.\d{4}-\d{2}\.[\w.]+\s\.*\s\[TPGs:\s\d+\]'\|'eui\.\w+\s\.*\s\[TPGs:\s\d+\]/)
#a = /iqn\.\d{4}-\d{2}\.[\w\.]+\s\.+\s\[TPGs:\s\d+\]/.match("iqn.2016-12.tst.com ..... [TPGs: 1]")
iqn_results = re_iqn_target.match("iqn.2017-01.suse.com ........... [TPGs: 12]")
puts iqn_results
re_eui_target = Regexp.new(/eui\.\w+\s\.+\s\[TPGs:\s\d+\]/)
eui_results = re_eui_target.match("eui.abcdef00123 ............... [TPGs: 22]")
puts eui_results
TargetList = []

test = Target.new

