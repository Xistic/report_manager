class Report
  attr_accessor :date_deadline, :days_to_deadline

  def initialize(date_deadline, days_to_deadline)
    @date_deadline = date_deadline
    @days_to_deadline = days_to_deadline
  end
end