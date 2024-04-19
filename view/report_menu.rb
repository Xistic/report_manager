require_relative '../controller/report_manager'

class ReportMenu
    
    def initialize
        @report_manager = ReportManager.new
    end

    def get_next_report
        return @report_manager.reports_filter
    end 

    def get_all_report

    end 

    private

   

end 