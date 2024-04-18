require 'json'
require 'date'

class ReportGenerator

    def initialize
      @holidays = load_json('consultant2024.json')  
      @today = Date.new(2024, 7, 10)
    end

    def get_the_nearest_report
        report_hashes = quarterly_report + monthly_report + annual_report
        sorted_reports = report_hashes.sort_by { |report_hash| report_hash[:days_to_deadline] }
        save_to_json('reports.json', sorted_reports)
        report_constructor(sorted_reports)
    end
      
    private

    def save_to_json(json_name, hashes)
        File.open(json_name, 'w') do |file|
          file.write(JSON.generate(hashes))
        end
    end
      
    def report_constructor(report_hashes)
        report_hashes.each do |report_hash|
            puts "#{report_hash[:type]} Report:"
            puts "Deadline Date: #{report_hash[:deadline_date].strftime('%Y-%m-%d')}"
            puts "Days to Deadline: #{report_hash[:days_to_deadline]}"
            puts "-------------------------"
        end
    end
      
    def monthly_report
        deadline_date = calculate_working_calendar_days(@today.next_month, 10)
        days_to_deadline = (deadline_date - @today).to_i
        report_hash = generate_report_hash('Monthly', deadline_date, days_to_deadline)
        [report_hash]
    end

    def quarterly_report 
        deadline_date = calculate_working_calendar_days(end_of_quarter(@today).next_month, 10)
        days_to_deadline = (deadline_date - @today).to_i
        report_hash = generate_report_hash('Quarterly', deadline_date, days_to_deadline)

        deadline_date_30 = Date.new(deadline_date.year, deadline_date.month, 30)
        days_to_deadline_30 = (deadline_date_30 - @today).to_i
        report_hash_30 = generate_report_hash('Quarterly-30', deadline_date_30, days_to_deadline_30)

        [report_hash, report_hash_30]
    end

    def annual_report 
        deadline_date = calculate_working_calendar_days(Date.new(@today.year + 1, 1, 30), 10)
        days_to_deadline = (deadline_date - @today).to_i
        report_hash = generate_report_hash('Annual', deadline_date, days_to_deadline)

        deadline_date_30 = Date.new(deadline_date.year, deadline_date.month, 30)
        days_to_deadline_30 = (deadline_date_30 - @today).to_i
        report_hash_30 = generate_report_hash('Annual-30', deadline_date_30, days_to_deadline_30)

        [report_hash, report_hash_30]
    end 

    def generate_report_hash(type, deadline_date, days_to_deadline)
        {
            type: type,
            deadline_date: deadline_date,
            days_to_deadline: days_to_deadline
        }
    end

    def calculate_working_calendar_days(start_date, working_calendar_days)

        current_day = Date.new(start_date.year, start_date.month, 1)
        case working_calendar_days
        when 10 
        
            while working_calendar_days >= 0
                unless weekend_or_holiday?(current_day)
                    working_calendar_days -= 1
                end
                current_day += 1
            end
        
            current_day + 1
        when 30 

            current_day = Date.new(start_date.year, start_date.month, working_calendar_days)

        end 
    end


    def weekend_or_holiday?(date)
        date.saturday? || date.sunday? || holiday?(date)
    end
    
    def holiday?(date)
        @holidays.include?(date.strftime("%Y-%m-%d"))
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
    
    def load_json(file_path)
        JSON.parse(File.read(file_path))
    end

end

report = ReportGenerator.new
report.get_the_nearest_report
