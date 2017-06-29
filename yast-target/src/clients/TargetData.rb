require "yast"
require "yast2/execute"

module Yast
  class TargetDataClass
    def test
       files = Yast::Execute.locally("ls", "-la", stdout: :capture)
       #files = Cheetah.run("ls", "-la", stdout: :capture)
       p files
       puts "testtesttest111111"
    end
    #
    # Get information about network interfaces from 'ip addr show'
    #
    def GetNetConfig
      out = Convert.to_map(
        Yast::SCR.Execute(Yast::Path.new(".target.bash_output"), "LC_ALL=POSIX ip addr show")
      )
      ls = out.fetch("stdout", "").split("\n")
      Yast::deep_copy(ls)
    end
  end
  TargetData = TargetDataClass.new
end