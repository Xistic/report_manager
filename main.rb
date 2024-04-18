require_relative 'models/report_manager.rb'

manager = ReportManager.new

manager.add_report('Monthly')
manager.add_report('Quarterly 10')
manager.add_report('Quarterly 30')
manager.add_report('Annual 10')
manager.add_report('Annual 30')

