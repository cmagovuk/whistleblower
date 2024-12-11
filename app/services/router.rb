class Step
    
    attr_accessor :page, :visited, :completed
    
    def initialize(p)
        @page = p
    end

end

class Router

    # the router is a helper that allows us to build a queue of pages the user must pass through
    # each step can be marked as completed or not

    @steps = []

    @current_page = nil

    def initialize
        @steps = [Step.new(:start),Step.new(:work_for_the_business), Step.new(:businesses), Step.new(:what_happened), Step.new(:evidence), Step.new(:include_contact), Step.new(:contact), Step.new(:review), Step.new(:summary)]
    end

    def steps
        return @steps
    end

    # given a page, return the step
    def step(reference_page)
        if reference_page.is_a? Symbol
            if @steps.select {|s| s.page == reference_page}.length > 0
                return @steps.select {|s| s.page == reference_page}.first
            else
                return nil
            end
        else
            return nil
        end
    end

    def reset
        this.initialize
    end
    
    # new pages are always added directly in front of the review page
    def remove_page(reference_page)
        if reference_page.is_a? Symbol
            _new_steps = []
            for s in @steps do
                if s.page != reference_page
                    _new_steps.push(s)
                end
            end
            @steps = _new_steps
            return true
        else
            return false
        end
    end


    # new pages are always added directly in front of the review page
    def add_page(reference_page)
        if reference_page.is_a? Symbol
            _new_steps = []
            for s in @steps do
                if s.page != :review
                    _new_steps.push(s)
                else
                    _new_steps.push(Step.new(reference_page))
                    _new_steps.push(s)
                end
            end
            @steps = _new_steps
            return true
        else
            return false
        end
    end

    def next_page(reference_page)

        # if review has not been visited then carry on forwards
        if step(:review).visited && step(:review).completed != true
            return :review
        else

            if step(:summary).visited
                return :summary
            else
                reference_page_index = @steps.find_index{ |s| s.page == reference_page }
                if !reference_page_index.nil?
                    if @steps.length > reference_page_index+1
                        
                        return @steps[reference_page_index+1].page
                    else
                        return nil
                    end
                else
                    return nil
                end
            end

        end
    end

    def previous_page(reference_page)

        if !step(:review).visited
            reference_page_index = @steps.find_index{ |s| s.page == reference_page}
            if !reference_page_index.nil?
                if reference_page_index>0
                    return @steps[reference_page_index-1].page
                else
                    return nil
                end
            else
                return nil
            end
        else
            return :review
        end

    end

    def current_page
        return @current_page
    end

    def set_visited(reference_page)
        i = @steps.find_index{ |s| s.page == reference_page}
        if !i.nil?
            @steps[i].visited = true
            @current_page = reference_page
        end
    end

    def set_completed(p)
        i = @steps.find_index{ |s| s.page == p}
        if !i.nil?
            @steps[i].completed = true
        end
    end

    def first_incomplete_page()
        @result = nil
        for s in @steps do
            if s.completed != true
                result = s.page
                break
            end
        end
        return result
    end

    

end