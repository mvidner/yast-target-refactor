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
str = File.readlines(file)
#puts str

TargetList = []

test = Target.new

