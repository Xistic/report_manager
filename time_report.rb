require 'date'
require 'json'

class ReportGenerator
  def initialize(holidays_file)
    @holidays = load_json(holidays_file)["holidays"]
    @today = Date.today
  end

  def next_report
    monthly_report 
    quarters_report 
    annual_report
  end 
  
  def monthly_report
    deadline = calculate_working_days(@today.next_month, 10)
    days_to_deadline = (deadline - @today).to_i
    puts "Monthly report deadline: #{deadline} : #{days_to_deadline}"
  end

  def quarters_report
    deadline_quarter = calculate_working_days(end_of_quarter(@today).next_month, 10)
    days_to_deadline = (deadline_quarter - @today).to_i
    puts "Quarterly report deadline 10 working days: #{deadline_quarter} : #{days_to_deadline}"
  
    next_month = deadline_quarter.next_month
    deadline_30 = Date.new(next_month.year, deadline_quarter.month , 30)
    days_to_deadline_30 = (deadline_30 - @today).to_i
    puts "Quarterly report deadline 30 days: #{deadline_30} : #{days_to_deadline_30}"
  end

  def annual_report
    deadline_next_year_10_days = calculate_working_days(Date.new(@today.year + 1, 1, 30), 10)
    days_to_deadline_10_days = (deadline_next_year_10_days - @today).to_i
    puts "Annual report deadline 10 working days: #{deadline_next_year_10_days} : #{days_to_deadline_10_days}"

    deadline_next_year_30_days = Date.new(@today.year + 1, 1, 30)
    days_to_deadline_30_days = (deadline_next_year_30_days - @today).to_i
    puts "Annual report deadline 30 days: #{deadline_next_year_30_days} : #{days_to_deadline_30_days}"
  end

  

  private

  def load_json(file)
    JSON.parse(File.read(file))
  end

  def end_of_quarter(day)
    case day.month
    when 1..3 
      return Date.new(day.year, 3, 31)
    when 4..6 
      return Date.new(day.year, 6, 30)
    when 7..9 
      return Date.new(day.year, 9, 30)
    when 10..12 
      return Date.new(day.year, 12, 31)
    end
  end
  
  def calculate_working_days(start_date, working_days)
    current_day = Date.new(start_date.year, start_date.month, 1)
  
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
end

report = ReportGenerator.new('consultant2024.json')
report.next_report
