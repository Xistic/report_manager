require_relative '../controller/report_manager'

class ReportMenu
    
    def initialize
        initialize_report_manager
    end
    
    def get_next_report
        update_report
        reports_filter
        
    end

    def refresh_folder
        reload_folder
    end
  
    private
    
    def initialize_report_manager
        @report_manager = ReportManager.new
    end
  
    def update_report
        @report_manager.update_report
    end
  
    def reports_filter
        @report_manager.reports_filter
    end
  
    def reload_folder
        @report_manager.reload_folder
    end

  end 