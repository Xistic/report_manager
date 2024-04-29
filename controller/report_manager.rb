require_relative '../models/report'
require_relative 'report_time_machine'
require 'json'
require 'date'

class ReportManager
  def initialize
    @time_machine = ReportTimeMachine.new
    @reports = {
      monthly: nil,
      quarterly_10: nil,
      quarterly_30: nil,
      annual_30: nil
    }
  end

  def get_reports
    @reports.each_key do |type|
      date_deadline = @time_machine.deadline_date(type)
      days_to_deadline = @time_machine.days_to_deadline(type)
      report = Report.new(date_deadline, days_to_deadline)
      @reports[type] = report
    end
  end

  def get_min_report
    get_reports
    min_days_to_deadline = 325
    min_days_report = []
    @reports.each_pair do |type, report|
      days_to_deadline = report.days_to_deadline
      if days_to_deadline <= min_days_to_deadline
        if days_to_deadline < min_days_to_deadline
          min_days_report = [] 
          min_days_to_deadline = days_to_deadline
        end
        min_days_report << {type: type, report: report}
      end
    end
    min_days_report.each do |min_report|
      type = min_report[:type]
      report = min_report[:report]
      puts "Тип: #{type} |_| Date deadline: #{report.date_deadline.strftime('%Y-%m-%d')} |_| Days to deadline: #{report.days_to_deadline}"
    end
  end
end
