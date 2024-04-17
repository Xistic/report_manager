require 'date'
require 'json'

class ReportGenerator
  def initialize(holidays_file, quarters_file)
    holidays_data = JSON.parse(File.read(holidays_file))
    @holidays = holidays_data["holidays"]
  
    @quarters = JSON.parse(File.read(quarters_file))
    @today = Date.today
  end
  
  def next_report
    
  end
  
  public 

  def monthly_report
    deadline = next_month_working_only(10)
    puts "Monthly report deadline: #{deadline}"
  end

  def quarterly_report

  end

  def annual_report

  end

  def next_month_working_only(working_days)
    next_month = @today.next_month
    days_left = working_days
    current_day = Date.new(next_month.year, next_month.month, 1)

    while days_left > 0

      if current_day.saturday? || current_day.sunday? || holiday?(current_day)
        current_day += 1
      else
        days_left -= 1
        current_day += 1
      end

    end

    current_day -1
  end
  
  def holiday?(date)
    @holidays.include?(date.strftime("%Y-%m-%d"))
  end

end