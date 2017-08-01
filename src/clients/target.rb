# Simple example to demonstrate object API for CWM

require_relative "example_helper"
require './src/lib/TargetData.rb'
require "cwm/widget"
require "ui/service_status"
require "yast"

Yast.import "CWM"
Yast.import "CWMTab"
Yast.import "TablePopup"
Yast.import "CWMServiceStart"
Yast.import "Popup"
Yast.import "Wizard"
Yast.import "CWMFirewallInterfaces"
Yast.import "Service"
Yast.import "CWMServiceStart"
Yast.import "UI"



class NoDiscoveryAuth_widget < ::CWM::CheckBox
  def initialize
    textdomain "example"
  end
  def label
    _("No Discovery Authentication")
  end
#auto called from Yast
  def init
    self.value = true #TODO read config
  end

  def store
    puts "IT IS #{value}!!!"
  end

  def handle 
    puts "Changed!"
  end

  def opt
    [:notify]
  end
end

class BindAllIP < ::CWM::CheckBox
  def initialize()
    textdomain "example"
  end
  def label
    _("Bind all IP addresses")
  end
#auto called from Yast
  def init
    self.value = true #TODO read config
  end

  def store
    puts "IT IS #{value}!!!"
  end

  def handle 
    puts "Changed!"
  end

  def opt
    [:notify]
  end
end

class UseLoginAuth < ::CWM::CheckBox
  def initialize()
    textdomain "example"
  end
  def label
    _("Use Login Authentication")
  end
#auto called from Yast
  def init
    self.value = true #TODO read config
  end

  def store
    puts "IT IS #{value}!!!"
  end

  def handle 
    puts "Changed!"
  end

  def opt
    [:notify]
  end
end


class Auth_by_Initiators_widget < ::CWM::CheckBox
  def initialize
    textdomain "example"
  end
  def label
    _("Authentication by initiators.\n")
  end
#auto called from Yast
  def init
    self.value = true #TODO read config
  end

  def store
    puts "IT IS #{value}!!!"
  end

  def handle 
    puts "Changed!"
  end

  def opt
    [:notify]
  end
end


class Auth_by_Targets_widget < ::CWM::CheckBox
  def initialize
    textdomain "example"
  end
  def label
    _("Autnentication by Targets")
  end
#auto called from Yast
  def init
    self.value = true #TODO read config
  end

  def store
    puts "IT IS #{value}!!!"
  end

  def handle 
    puts "Changed!"
  end

  def opt
    [:notify]
  end
end

class UserName < CWM::InputField
  def initialize(str)
    @config = str
  end

  def label
    _("Username:")
  end

  def init
    self.value = @config
    printf("Username InputField init, got default value %s.\n",@config)
  end

  def store
    @config = value
    printf("Username Inputfield will store the value %s.\n", @config)
  end
end

class Password < CWM::InputField
  def initialize(str)
    @config = str
  end

  def label
    _("Password:")
  end

  def init
    self.value = @config
    printf("Password InputField init, got default value %s.\n",@config)
  end

  def store
    @config = value
    printf("Password Inputfield will store the value %s.\n", @config)
  end
end




class MutualUserName < CWM::InputField
  def initialize(str)
    @config = str
  end

  def label
    _("Mutual Username:")
  end

  def init
    self.value = @config
    printf("Mutual Username InputField init, got default value %s.\n",@config)
  end

  def store
    @config = value
    printf("Mutual Username Inputfield will store the value %s.\n", @config)
  end
end

class MutualPassword < CWM::InputField
  def initialize(str)
    @config = str
  end

  def label
    _("Mutual Password:")
  end

  def init
    self.value = @config
    printf("Mutual Password InputField init, got default value %s.\n",@config)
  end

  def store
    @config = value
    printf("Mutual Password Inputfield will store the value %s.\n", @config)
  end
end

module Yast
  class ServiceTab < ::CWM::Tab
    #@fire_wall_service = nil
    include Yast::I18n
    include Yast::UIShortcuts
    def initialize
     #Yast.import "SuSEFirewall"
      self.initial = false
      @service = Yast::SystemdService.find("targetcli")
      @service_status = ::UI::ServiceStatus.new(@service, reload_flag: true, reload_flag_label: :restart)
      #@fire_wall_service = Yast::FirewallServices.new
    end

    def contents
      HBox(
         ::CWM::WrapperWidget.new(
           CWMFirewallInterfaces.CreateOpenFirewallWidget("services" => ["service:sshd"]),
           id: "firewall"
         ),
        @service_status.widget
       )
    end
  
    def label
      _("Service")
    end
  end
end
class GlobalTab < ::CWM::Tab
  def initialize
    self.initial = true
  end

  def contents
    VBox(
      #HStretch(),
      VStretch(),
      NoDiscoveryAuth_widget.new,
      Auth_by_Targets_widget.new,
      HBox(
        UserName.new("test username"),
        Password.new("test password")
      ),
      Auth_by_Initiators_widget.new,
      HBox(
        MutualUserName.new("test mutual username"),
        MutualPassword.new("test mutual password")
      )
    )
  end

  def label
    _("Global")
  end
end


class TargetsTab < ::CWM::Tab
  def initialize
    self.initial = false
  end

  def contents
    VBox(
      HStretch(),
      VStretch(),
      TargetsTableWidget.new
    )
  end

  def label
    _("Targets")
  end
end


class TargetNameInput < CWM::InputField
  def initialize(str)
    @config = str
  end

  def label
    _("Target")
  end

  def init
    self.value = @config
    printf("TargeteName InputField init, got default value %s.\n",@config)
  end

  def store
    @config = value
    printf("TargetName Inputfield will store the value %s.\n", @config)
  end
end

class TargetIdentifierInput < CWM::InputField
  def initialize(str)
    @config = str
  end

  def label
    _("Identifier")
  end

  def init
    self.value = @config
    printf("Target Identifier InputField init, got default value %s.\n",@config)
  end

  def store
    @config = value
    printf("Target Identifier Inputfield will store the value %s.\n", @config)
  end
end

class PortalGroupInput < CWM::IntField
  def initialize(str)
    @config = str
  end

  def label
    _("Portal group")
  end

  def init
    self.value = @config
    printf("Target Portal Group InputField init, got default value %s.\n",@config)
  end

  def store
    @config = value
    printf("Target Portal Group will store the value %s.\n", @config)
  end

  def minimum
    return 0
  end
end

class TargetPortNumberInput < CWM::IntField
  def initialize(str)
    @config = str
  end

  def label
    _("Port Number")
  end

  def init
    self.value = @config
    printf("Target port number InputField init, got default value %s.\n",@config)
  end

  def store
    @config = value
    printf("Target port number will store the value %s.\n", @config)
  end

  def minimum
    return 0
  end
end


class IpSelectionComboBox < CWM::ComboBox
  def initialize()
    #@config = myconfig
  end

  def label
    _("IP Address:")
  end

  def init
    #self.value = @config.value
  end

  def store
    #@config.value = value
    puts self.value
    puts get_addr
  end
  
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

  def addresses
    #["first", "second", "third","forth"]
    self.GetNetConfig
  end
  
  def items
    result = []
    addresses.each_with_index do |a, i|
      result << [ Id(i), a]
    end
    result
  end

  def get_addr
   return addresses[self.value[0]]
  end


  def opt
    [:notify]
  end
end


class AddTargetWidget < CWM::CustomWidget
  include Yast
  include Yast::I18n
  include Yast::UIShortcuts
  include Yast::Logger
  @target_name_input_field = nil
  @target_identifier_input_field = nil
  @target_portal_group_field = nil
  @target_port_num_field = nil
  @target_bind_all_ip_checkbox = nil
  def initialize
    self.handle_all_events = true
    @target_name_input_field = TargetNameInput.new("iqn.2017-04.suse.com.prg.test")
    @target_identifier_input_field = TargetIdentifierInput.new("Random 12345")
    @target_portal_group_field = PortalGroupInput.new(5)
    @target_port_num_field = TargetPortNumberInput.new(3260)
    #@target_bind_all_ip_checkbox = BindAllIP.new()
  end

  def contents
   
    VBox(
      HBox(
        @target_name_input_field,
        @target_identifier_input_field,
        @target_portal_group_field
      ),
      HBox(
        IpSelectionComboBox.new,
        @target_port_num_field,
      ),
      VBox(
        BindAllIP.new,
        UseLoginAuth.new,
      ),
      LUNsTableWidget.new,
    )
  end

  def handle(event)
    puts event 
    puts @target_name_input_field.value
    puts @target_identifier_input_field.value
    puts @target_portal_group_field.value
    puts @target_port_num_field.value
    nil
  end
end




class TargetsTableWidget < CWM::CustomWidget
  include Yast
  include Yast::I18n
  include Yast::UIShortcuts
  include Yast::Logger
  def initialize
    self.handle_all_events = true
  end

  def contents
    VBox(
      Table(
         Id(:targets_table),
         Header("Targets", "Portal Group", "TPG Status"),
           [
             Item(Id(1), "iqn.2017-04.suse.com.lszhu.target.sn.abcdefghisdljhlshjl", 1,"Enabled"),
           ]
       ),
       HBox(
         PushButton(Id(:add), _("Add")),
         PushButton(Id(:edit), _("Edit")),
         PushButton(Id(:delete), _("Delete"))
       )
  )
  end

  def handle(event)
    puts event
    case event["ID"]
      when :add
        puts "Clicked Add button!"
        puts Yast::UI.QueryWidget(Id(:targets_table), :CurrentItem)
        puts Yast::UI.QueryWidget(Id(:targets_table), :Items)
        Yast::UI.ChangeWidget(Id(:targets_table), Cell(1, 1), "testtest")
        add_target_page = AddTargetWidget.new
        contents = VBox(add_target_page,HStretch(),VStretch())
 
        Yast::Wizard.CreateDialog
        CWM.show(contents, caption: _("Add iSCSI Target"))
         Yast::Wizard.CloseDialog
         
     end
     nil
  end

  def help
    _("demo help")
  end
end

class LUNsTableWidget < CWM::CustomWidget
  include Yast
  include Yast::I18n
  include Yast::UIShortcuts
  include Yast::Logger
  def initialize
    self.handle_all_events = true
  end

  def contents
    VBox(
      Table(
         Id(:targets_table),
         Header("LUN", "Name", "path"),
           [
             Item(Id(1), "0", "test_lun","/test/test"),
           ]
       ),
       HBox(
         PushButton(Id(:add), _("Add")),
         PushButton(Id(:edit), _("Edit")),
         PushButton(Id(:delete), _("Delete"))
       )
  )
  end

  def handle(event)
    puts event
    case event["ID"]
      when :add
        puts "Clicked Add button!"
        #puts Yast::UI.QueryWidget(Id(:targets_table), :CurrentItem)
        #puts Yast::UI.QueryWidget(Id(:targets_table), :Items)
        #Yast::UI.ChangeWidget(Id(:targets_table), Cell(1, 1), "testtest")
        #add_target_page = AddTargetWidget.new
        #contents = VBox(add_target_page,HStretch(),VStretch())
 
        #Yast::Wizard.CreateDialog
        #CWM.show(contents, caption: _("Add iSCSI Target"))
         #Yast::Wizard.CloseDialog
         
     end
     nil
  end

  def help
    _("demo help")
  end
end



module Yast
  class ExampleDialog
    include Yast::I18n
    include Yast::UIShortcuts
    include Yast::Logger
    #require './src/clients/TargetData.rb'

    def initialize
       #TargetData.test
       #p TargetData.GetNetConfig
    end

    def run
      textdomain "example"

      global_tab = GlobalTab.new
      targets_tab = TargetsTab.new
      service_tab =ServiceTab.new

      tabs = ::CWM::Tabs.new(service_tab,global_tab,targets_tab)

      contents = VBox(tabs,VStretch())

      Yast::Wizard.CreateDialog
      CWM.show(contents, caption: _("Yast iSCSI Targets"))
      Yast::Wizard.CloseDialog

     # log.info "Lucky number: #{lucky_number_tab.result}, true love: #{true_love_tab.result}"
    end
  end
end

Yast::ExampleDialog.new.run
