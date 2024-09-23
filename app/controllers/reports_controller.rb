class ReportsController < ApplicationController

    def home
        if (session[:reports_login].present? && session[:reports_login] == request.remote_ip)
            redirect_to "/reports/menu"
        else
            redirect_to "/reports/login"
        end
    end

    def login
        
    end

    def login_submit
        if params["login"]["reports_password"].to_s == ENV["REPORTS_PASSWORD"].to_s
            session[:reports_login] = request.remote_ip
            redirect_to "/reports/menu"
        else
            redirect_to "/reports/login?login=fail"
        end
    end

    def logout
        session.delete(:reports_login)
        redirect_to "/reports"
    end
    
    def menu
        redirect_to "/reports/login" unless (session[:reports_login].present? && session[:reports_login] == request.remote_ip)
    end

    def report_summary
        redirect_to "/reports/login" unless (session[:reports_login].present? && session[:reports_login] == request.remote_ip)
    end

end