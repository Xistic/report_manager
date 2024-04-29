require_relative '../controller/report_manager'

class ReportMenu
  def initialize
    @report_manager = ReportManager.new
  end
  
  def get_next_report
    get_min_report
  end
  
  private
  
  def get_min_report
    @report_manager.get_min_report
  end
end 