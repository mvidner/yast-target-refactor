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
re = Regexp.new("iqn\.\d{4}-\d{2}\.[\w.]+\s\.*\s\[TPGs:\s\d+\]'\|'eui\.\w+\s\.*\s\[TPGs:\s\d+\]")

#test = str.split(/'iqn'/)
if re =~"iqn.2016-12.suse.com.lszhu"
   puts "matched"
end
TargetList = []

test = Target.new

