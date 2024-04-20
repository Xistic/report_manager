require_relative '../controller/report_manager'

class ReportMenu

    def initialize
        @report_manager = ReportManager.new
    end

    def get_next_report
        @report_manager.update_report
        @report_manager.reports_filter
    end 

    def refresh_folder
        @report_manager.reload_folder
    end 

end 