# require_relative 'controller/report_manager.rb'
require_relative 'view/report_menu.rb'

# manager = ReportManager.new

# manager.get_report('Monthly')
# manager.get_report('Quarterly 10')
# manager.get_report('Quarterly 30')
# manager.get_report('Annual 10')
# manager.get_report('Annual 30')
# manager.get_report ('Annual 30')

report_menu_tool = ReportMenu.new

report_menu_tool.get_next_report

