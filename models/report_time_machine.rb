require_relative 'report_manager'
require 'date'
require 'json'


class ReportTimeMachine

    def initialize
        @today = Date.today
        @holidays = load_json('chest/consultant2024.json')
    end

    def deadline_date(report_type)
        case report_type.downcase
        when 'monthly'
            get_deadline(report_type)
        when 'quarterly'
            get_deadline(report_type)
        when 'annual'
            get_deadline(report_type)
        else
            raise ArgumentError, "Что за тип, братишка?: #{report_type}"
        end 
    end

    def days_to_deadline(report_type)
        case report_type.downcase
        when 'monthly'
            (get_deadline(report_type) - @today).to_i 
        when 'quarterly'
            (get_deadline(report_type) - @today).to_i
        when 'annual'
            (get_deadline(report_type) - @today).to_i
        else
            raise ArgumentError, "Что за тип, братишка?: #{report_type}"
        end 
    end

    private 

    def get_deadline(report_type)
        case report_type.downcase
        when 'monthly'
            working_days_only(@today.next_month)
        when 'quarterly'
            working_days_only(end_of_quarter(@today).next_month) 
        when 'annual'
            working_days_only(Date.new(@today.year + 1, 1, 30))
        else
            raise ArgumentError, "Что за тип, братишка?: #{report_type}"
        end 
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
