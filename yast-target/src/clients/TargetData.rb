require "yast"
require "yast2/execute"

module Yast
  class TargetDataClass
    def GetNetConfig
       ip_list = Array.new
       re_ipv4 = Regexp.new(/[\d+\.]+\//)
       re_ipv6 = Regexp.new(/[\w+\:]+\//)
       ret = Yast::Execute.locally("ip", "a", stdout: :capture)
       ip = ret.split("\n")
       ip.each do |line|
         line = line.strip
         if(line.include?("inet") && !line.include?("deprecated")) # don't show deprecated IPs
           if line.include?("inet6")
             ip_str = re_ipv6.match(line).to_s.gsub!("/","")
             if ip_str.start_with?("::1")
               next
             elsif ip_str.start_with?("fe80:")
               next
             else
               p ip_str
               ip_list.push(ip_str)
             end
           else
             #delete "/", and drop 127.x.x.x locall address
             ip_str = re_ipv4.match(line).to_s.gsub!("/","")
             #p ip_str
             if ip_str.start_with?("127.")
               next
             else
               p ip_str
               ip_list.push(ip_str)
             end
           end
         end
       end
       puts "testtesttest111111"
       return ip_list
    end



   #
    # Get list of IP addresses (filters stdout of 'ip addr show')
    #
    # @return [Array]<String> list of IP addresses (IPv4 and IPv6), if no IP is found
    #                         returns array with an empty string element
    #
    def GetIpAddr
      ip_list = GetNetConfig()
      ip_list.select! do |line|
        line.include?("inet") && !line.include?("deprecated") # don't show deprecated IPs
      end

      ip_list = ip_list.map do |ip|
        ip.lstrip!
        case ip
        when /^inet *([.\d]+)\/.*/
          $1
        when /^inet6 *([.:\w]+)\/.*/
          $1
        else
          ip
        end
      end

      ip_list.reject! do |address|
        address.start_with?("127.") ||  # local IPv4
          address.start_with?("::1") || # local IPv6
          address.start_with?("fe80:")  # scope link IPv6
      end

      ip_list = [""] if ip_list.empty?
      Builtins.y2milestone("GetIpAddr: %1", ip_list)
      deep_copy(ip_list)
    end


    
  end
end