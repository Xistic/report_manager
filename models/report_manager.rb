require_relative 'report'
require_relative 'report_time_machine'
require 'json'

class ReportManager
  def initialize
    @time_machine = ReportTimeMachine.new
    @report_files = {
      monthly: 'storage_reports/monthly_report.json',
      quarterly_10: 'storage_reports/quarterly_report_10.json',
      quarterly_30: 'storage_reports/quarterly_report_30.json',
      annual_10: 'storage_reports/annual_report_10.json',
      annual_30: 'storage_reports/annual_report_30.json'
    }
  end

  def add_report(type)
    date_deadline = @time_machine.deadline_date(type.downcase.gsub(' ', '_'))
    days_to_deadline = @time_machine.days_to_deadline(type.downcase.gsub(' ', '_'))

    report = Report.new(type, date_deadline, days_to_deadline)

    puts report

    report_file = @report_files[type.downcase.gsub(' ', '_').to_sym]
    File.open(report_file, 'w') do |file|
      file.write(report.to_json)
    end
  end

end
