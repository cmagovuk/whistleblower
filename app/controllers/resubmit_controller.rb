class ResubmitController < ApplicationController

    before_action :init, except: [:login, :login_submit, :login_failed]

    def login
        # shows the login form
    end

    def login_submit
        # processes login
        if params[:login][:access_code] == ENV["RESUBMIT_ACCESS_CODE"]
            session[:resubmit_access] = true
            redirect_to :controller => :resubmit, :action => :list
        else
            session[:resubmit_access] = nil
            redirect_to :controller => :resubmit, :action => :login_failed
        end
    end

    def login_failed
        # render that login failed

    end

    def resubmit
        # show the form
    end

    def resubmit_submit
        # takes data from the form and redirects to confirm
        @submission_id = params[:resubmission][:submission_id]
        redirect_to :controller => :resubmit, :action => :confirm, :submission_id => @submission_id and return
    end

    def confirm
        # fetches the appropriate record to render it
        @submission_id = params[:submission_id]
        begin
            @submission = Submission.find(@submission_id)
        rescue
            redirect_to :controller => :resubmit, :action => :not_found
        end
    end

    def not_found
        # tells the user the submission was not found
    end

    def confirm_submit
        # actions the resubmission
        begin
            @submission = Submission.find(params[:resubmission][:submission_id])
            puts(params)
            Transmitter.Transmit(@submission)
            redirect_to :controller => :resubmit, :action => :resubmitted
        rescue
            redirect_to :controller => :resubmit, :action => :not_found
        end
    end

    def resubmitted
        # confirms the resubmission has happened
    end

    def list

        @submissions = Submission.order(:created_at).last(100)

    end

private

    def init
        if session[:resubmit_access].nil?
            redirect_to :controller => :resubmit, :action => :login and return
        end
    end

end