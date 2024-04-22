require_relative '../models/report'
require_relative 'report_time_machine'
require 'json'
require 'date'

class ReportManager
  def initialize
    @time_machine = ReportTimeMachine.new
    @report_files = {
      monthly: 'storage_reports/monthly_report.json',
      quarterly_10: 'storage_reports/quarterly_report_10.json',
      quarterly_30: 'storage_reports/quarterly_report_30.json',
      annual_30: 'storage_reports/annual_report_30.json'
    }
  end

  def get_report(type)
    date_deadline = @time_machine.deadline_date(type)
    days_to_deadline = @time_machine.days_to_deadline(type)
    report = Report.new(type, date_deadline, days_to_deadline)
    report_file = @report_files[type.to_sym]
    write_report_to_file(report, report_file)
  end

  def reports_filter
    min_days_to_deadline = 325
    min_days_report = []
    @report_files.each do |type, file_path|
      report_data = load_report_data(file_path)
      if report_data['Days-to-Deadline'] <= min_days_to_deadline
        if report_data['Days-to-Deadline'] < min_days_to_deadline
          min_days_report = []
          min_days_to_deadline = report_data['Days-to-Deadline']
        end
          min_days_report << report_data
      end
    end
    puts min_days_report
  end

  def update_report()
    @report_files.each do |type, file_path|
      report_data = load_report_data(file_path)
      if @time_machine.check_report_condition(report_data, type)
        days_to_deadline = @time_machine.check_report_condition(report_data, type)
        report = Report.new(type, report_data['Date-Deadline'], days_to_deadline)
        report_file = @report_files[type.to_sym]
        write_report_to_file(report, report_file)
      else 
        get_report(type) 
      end
    end
  end 

  def reload_folder 
    @report_files.each do |type, file_path|
      get_report(type)
    end
  end 

  private

  def load_report_data(file_path)
    if File.exist?(file_path)
      JSON.parse(File.read(file_path))
    end
  end 

  def write_report_to_file(report, file_path)
    File.open(file_path, 'w') do |file|
      file.write(report.to_json)
    end
  end
end
