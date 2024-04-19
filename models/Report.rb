class Report

    attr_accessor :type, :date_deadline, :days_to_deadline
  
    def initialize(type, date_deadline, days_to_deadline)
        @type = type
        @date_deadline = date_deadline
        @days_to_deadline = days_to_deadline
    end

    def to_json
        {
          "Type" => @type,
          "Date-Deadline" => @date_deadline,
          "Days-to-Deadline" => @days_to_deadline
        }.to_json
    end

end