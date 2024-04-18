class Report

    attr_accessor :type, :date_deadline, :days_to_deadline
  
    def initialize(type, date_deadline, days_to_deadline)
        @date_deadline = date_deadline
        @days_to_deadline = days_to_deadline
    end

end