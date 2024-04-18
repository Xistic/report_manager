require_relative 'report'
require_relative 'report_time_machine'
require 'json'

class ReportManager
  def initialize
    @time_machine = ReportTimeMachine.new
    @report_files = {
      monthly: 'monthly_report.json',
      quarterly_10: 'quarterly_report_10.json',
      quarterly_30: 'quarterly_report_30.json',
      annual_10: 'annual_report_10.json',
      annual_30: 'annual_report_30.json'
    }
  end

  def add_report(type)
    date_deadline = @time_machine.deadline_date(type)
    days_to_deadline = @time_machine.days_to_deadline(type)

    report = Report.new(type, date_deadline, days_to_deadline)

    report_file = @report_files[type.downcase.gsub(' ', '_').to_sym]
    File.open(report_file, 'w') do |file|
      file.write(report.to_json)
    end
  end

  def load_report(type)
    report_file = @report_files[type.downcase.gsub(' ', '_').to_sym]
    JSON.parse(File.read(report_file))
  end
end
