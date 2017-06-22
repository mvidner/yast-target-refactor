require "yast"

module Yast
  class TargetDataClass
    def test
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