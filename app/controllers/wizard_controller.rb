class WizardController < ApplicationController
    
    before_action :init

    def start

        session[:submission_id] = nil

        @submission = Submission.new
        @submission.router.set_visited(:start)
        @submission.status = :start
        
    end

    def start_submit

        # Create the new submission
        @submission = Submission.new
        @submission.status = :start
        @submission.router.set_visited(:start)
        @submission.router.set_completed(:start)
        @submission.save(:validate => false)
        
        session[:submission_id] = @submission.id
        
        redirect_to :controller => :wizard, :action => @submission.router.next_page(:start) and return
        
    end

    def businesses

        # record arrival at page
        @submission.router.set_visited(:businesses)
        @submission.status = :businesses
        @submission.save(:validate => false)

    end

    def businesses_submit

        # did we add a business?
        if @submission.businesses.count > 0

            # record submit happened
            @submission.router.set_completed(:businesses)
            @submission.status = :businesses
            @submission.save(:validate => false)
            
            redirect_to :controller => :wizard, :action => @submission.router.next_page(:businesses) and return

        else
            @submission.errors.add(:businesses, I18n.t("errors.businesses.no_businesses"))
            render :businesses
        end

    end

    def business_add
        @business = @submission.businesses.new
    end

    def business_add_submit
        @business = @submission.businesses.new(params.require(:business).permit(:submission_id, :business_name, :business_address, :business_postcode, :business_url))
        if @business.save
            redirect_to :controller => :wizard, :action => :businesses and return
        else            
            render :business_add and return
        end
    end

    def business_edit
        @business = @submission.businesses.where(id: params[:business_id]).first
    end

    def business_edit_submit
        @business = @submission.businesses.where(id: params[:business][:id]).first
        if @business.update(params.require(:business).permit(:submission_id, :id, :business_name, :business_address, :business_postcode, :business_url))
            redirect_to :controller => :wizard, :action => :businesses and return
        else
            render :business_edit and return
        end
    end

    def business_remove
        @business = @submission.businesses.where(id: params[:business_id]).first
        if !@business.nil?
            @business.destroy
        end
        redirect_to :controller => :wizard, :action => :businesses, :method => 'GET' and return
    end

    def what_happened
        # record arrival at page
        @submission.router.set_visited(:what_happened)
        @submission.status = :what_happened
        @submission.save(:validate => false)
    end

    def what_happened_submit
        
        if @submission.update(params.require(:submission).permit(:what_happened))

            # record submit happened
            @submission.router.set_completed(:what_happened)
            @submission.status = :what_happened
            @submission.save(:validate => false)

            redirect_to :controller => :wizard, :action => @submission.router.next_page(:what_happened) and return

        else
            render :what_happened and return
        end

    end

    def evidence
        # record arrival at page
        @submission.router.set_visited(:evidence)
        @submission.status = :evidence
        @submission.save(:validate => false)
    end

    def evidence_submit
        
        # record submit happened
        @submission.router.set_completed(:evidence)
        @submission.status = :evidence
        @submission.save(:validate => false)

        redirect_to :controller => :wizard, :action => @submission.router.next_page(:evidence) and return

    end

    def evidence_upload

        if !params[:submission].nil?
            if @submission.valid_file?(params[:submission][:evidence_files])
                @submission.evidence_files.attach(params[:submission][:evidence_files])
                redirect_to :controller => :wizard, :action => :evidence and return
            else
                render :evidence and return
            end
        else
            @submission.errors.add(:evidencefiles, I18n.t("errors.upload.no_file_error_message"))
            render :evidence and return
        end

    end

    def evidence_remove

        @evidence_file = @submission.evidence_files.where(id: params[:evidence_id]).first
        if !@evidence_file.nil?
            @evidence_file.purge
            redirect_to :controller => :wizard, :action => :evidence and return
        else
            render :evidence and return
        end

    end

    def include_contact

        # record arrival at page
        @submission.router.set_visited(:include_contact)
        @submission.status = :include_contact
        @submission.save(:validate => false)

    end
    
    def include_contact_submit

        if !params[:submission][:include_contact].blank?

            # record submit happened
            @submission.router.set_completed(:include_contact)
            @submission.status = :include_contact
            @submission.include_contact = params[:submission][:include_contact]

            # change the page sequence to include the contact page or not
            if @submission.include_contact == "yes"

                # inject the contact page into the router if it's not already there
                if @submission.router.step(:contact).nil?
                    @submission.router.add_page(:contact)
                end
                
            else

                # clear the contact details
                @submission.contact_name = nil
                @submission.contact_email_address = nil
                @submission.contact_telephone_number = nil

                # remove the contact page from the router
                @submission.router.remove_page(:contact)

            end

            @submission.save(:validate => false)

            redirect_to :controller => :wizard, :action => @submission.router.next_page(:include_contact) and return

        else

            @submission.errors.add(:include_contact, I18n.t("errors.include_contact.no_option_chosen"))
            render :include_contact and return

        end

    end

    def contact

        # record arrival at page
        @submission.router.set_visited(:contact)
        @submission.status = :contact
        @submission.save(:validate => false)

    end

    def contact_submit

        if @submission.update(params.require(:submission).permit(:contact_name, :contact_email_address, :contact_telephone_number))

            # record submit happened
            @submission.router.set_completed(:contact)
            @submission.status = :contact
            @submission.save(:validate => false)

            redirect_to :controller => :wizard, :action => @submission.router.next_page(:contact) and return

        else
            render :contact and return
        end

    end

    def review
        # record arrival at page
        @submission.router.set_visited(:review)
        @submission.status = :review
        @submission.save(:validate => false)
    end

    def review_submit

        # todo - transmit!

        # record submit happened
        @submission.router.set_completed(:review)
        @submission.status = :review
        @submission.save(:validate => false)

        # calculate the new reference_index and reference_number
        @reference_index = Submission.maximum("reference_index")
        if @reference_index.nil?
            @reference_index = 1
        else
            @reference_index += 1
        end

        # update the submission
        @submission.reference_index = @reference_index
        @submission.reference_number = "CMA-MWR-" + @reference_index.to_s.rjust(5,"0")
        @submission.save(:validate => false)

        # transmit the data
        Transmitter.Transmit(@submission)
        @submission.save(:validate => false)

        # Send a notification if required
        Notifier.Send(@submission) if @submission.contact_email_address.present?
        
        redirect_to :controller => :wizard, :action => @submission.router.next_page(:review) and return

    end
    
    def summary
        # record arrival at page
        @submission.router.set_visited(:summary)
        @submission.status = :summary
        @submission.save(:validate => false)

        @service_review_url = ENV.fetch("SERVICE_REVIEW_URL")
    end

    def print
        
    end

    def test
        
    end


private

    def init

        if !session[:submission_id].nil?

            begin
                # retrieve the submission
                @submission = Submission.find(session[:submission_id])
                
                
                
                @requested_page = request.path.split('/').reject(&:blank?).last.to_sym

                # is the page being requested in the route?
                if !@submission.router.step(@requested_page).nil?
                
                    # does a summary step exist in the route?
                    if !@submission.router.step(:summary).nil?

                        # check if we have already got to the summary page, and the requested page is not an exception
                        #@requested_page != :summary && @requested_page != :print && @requested_page != :start
                        
                        if @submission.router.step(:summary).visited && ( ![:start,:print,:summary].include? @requested_page )
                            redirect_to :controller => :wizard, :action => :summary and return
                        else
                            # check if the requested page is appropriate
                            if (@requested_page != @submission.router.first_incomplete_page()) and (@submission.router.step(@requested_page).completed != true)
                                # redirect to the first incomplete page instead
                                redirect_to :controller => :wizard, :action => @submission.router.first_incomplete_page() and return
                            end
                        end
                    end

                else

                    # requested page does not exist in the route
                    # this could still be a submit though

                end

            rescue
                @submission = Submission.new    
            end

        else    
            @submission = Submission.new            
        end

    end



end
