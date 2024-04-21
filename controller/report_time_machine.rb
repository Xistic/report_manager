require_relative 'report_manager'
require 'date'
require 'json'


class ReportTimeMachine
  def initialize
    @today = Date.today
    @holidays = load_json('chest/consultant2024.json')
  end

  def deadline_date(report_type)
    get_deadline(report_type)
  end

  def days_to_deadline(report_type)
    (get_deadline(report_type) - @today).to_i 
  end

  def check_report_condition(report_data, type)
    if report_data && report_data['Date-Deadline']
      deadline = Date.parse(report_data['Date-Deadline'])
      if deadline > @today 
        return days_to_deadline_fresh(deadline)
      end 
    end
    false
  end

  private 

  def days_to_deadline_fresh(deadline)
    (deadline - @today).to_i
  end

  def get_deadline(report_type)
    case report_type.downcase
    when :monthly
      working_days_only(@today.next_month)
    when :quarterly_10
      working_days_only(end_of_quarter(@today).next_month) 
    when :quarterly_30
      quarterly_start = end_of_quarter(@today)
    when :annual_30
      Date.new(@today.year + 1, 1, 30)
    else
      raise ArgumentError, "Что за тип, братишка?: #{report_type}"
    end 
  end

  def end_of_quarter(day)
    case day.month
    when 4 
      Date.new(day.year, 4, 30)
    when 7
      Date.new(day.year, 7, 30)
    when 10 
      Date.new(day.year, 10, 30)
    end
  end

  def working_days_only(start_month)
    current_day = Date.new(start_month.year, start_month.month, 1)
    working_days = 10
    until working_days == 0
      current_day += 1
      working_days -= 1 unless weekend_or_holiday?(current_day)
    end
    current_day
  end 

  def weekend_or_holiday?(date)
    date.saturday? || date.sunday? || holiday?(date)
  end
  
  def holiday?(date)
    @holidays.include?(date.strftime("%Y-%m-%d"))
  end

  def load_json(file_path)
    JSON.parse(File.read(file_path))
  end
end 
