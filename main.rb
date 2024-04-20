require_relative 'view/report_menu.rb'
require 'timecop'

Timecop.freeze(Time.new(2020, 6, 18))
report_menu_tool = ReportMenu.new

#report_menu_tool.get_next_report
#report_menu_tool.refresh_folder

Timecop.return

