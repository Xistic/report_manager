require 'date'
require 'holidays'

class ReportTimeMachine
  def initialize
    @today = Date.today
  end

  def deadline_date(report_type)
    get_deadline(report_type)
  end
  
  def days_to_deadline(report_type)
    (get_deadline(report_type) - @today).to_i
  end

  private 

  def get_deadline(report_type)
    case report_type
    when :monthly
      if tenth_workday_of_month(@today) < @today
        tenth_workday_of_month(@today.next_month)
      else 
        tenth_workday_of_month(@today)
      end 
    when :quarterly_10
      tenth_workday_of_month(start_of_quarter(@today)) 
    when :quarterly_30
      end_of_quarter(@today)
    when :annual_30
      Date.new(@today.year + 1, 1, 30)
    else
      raise ArgumentError, "Unknown report type: #{report_type}"
    end 
  end
  
  def end_of_quarter(day)
    case day.month
    when 3, 4
      Date.new(day.year, 4, 30)
    when 6, 7
      Date.new(day.year, 7, 30)
    when 9, 10
      Date.new(day.year, 10, 30)
    else 
      Date.new(day.year + 1, 1, 30)
    end
  end

  def start_of_quarter(day)
    case day.month
    when 1..3
      Date.new(day.year, 4, 1)
    when 4..6
      Date.new(day.year, 7, 1)
    when 7..9
      Date.new(day.year, 10, 1)
    else 
      Date.new(day.year + 1, 1, 30)
    end
  end

  def tenth_workday_of_month(day)
    date = Date.new(day.year, day.month, 1)
    workdays_count = 0
    while workdays_count < 10
      workdays_count += 1 unless Holidays.on(date, :ru).any? || date.saturday? || date.sunday?
      date += 1
    end
    date - 1 
  end
end 
