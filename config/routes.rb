Rails.application.routes.draw do
  resource :cookies,
           path: "/about/cookies",
           path_names: { edit: "/" },
           only: %i[edit update create]

  
  get "pages/:page", to: "pages#show"
  get "/404", to: "errors#not_found", via: :all
  get "/422", to: "errors#unprocessable_entity", via: :all
  get "/500", to: "errors#internal_server_error", via: :all
  get "/503", to: "errors#service_unavailable", via: :all

  # redirect no URL
  get  "" => redirect("/wizard/start")
  
  
  # redirect only the wizard
  get  "/wizard" => redirect("/wizard/start")
  
  # start page
  get  "/wizard/start", to: "wizard#start", via: :all
  get "/wizard/start_submit", to: "wizard#start_submit", via: :all

  # work_for_the_business page
  get "/wizard/work_for_the_business", to: "wizard#work_for_the_business", via: :all
  post "/wizard/work_for_the_business", to: "wizard#work_for_the_business_submit", via: :all

  # businesses page
  get  "/wizard/businesses", to: "wizard#businesses", via: :all
  post "/wizard/businesses", to: "wizard#businesses_submit", via: :all

  # business add page
  get  "/wizard/business/add", to: "wizard#business_add", via: :all
  post "/wizard/business/add", to: "wizard#business_add_submit", via: :all

  # business edit page
  get  "/wizard/business/edit", to: "wizard#business_edit", via: :all
  post "/wizard/business/edit", to: "wizard#business_edit_submit", via: :all

  # business remove action
  get "/wizard/business/remove", to: "wizard#business_remove", via: :all

  # what happened page
  get  "/wizard/what_happened", to: "wizard#what_happened", via: :all
  post "/wizard/what_happened", to: "wizard#what_happened_submit", via: :all

  # evidence page
  get  "/wizard/evidence", to: "wizard#evidence", via: :all
  post "/wizard/evidence", to: "wizard#evidence_submit", via: :all

  # evidence upload
  patch "/wizard/evidence/upload", to: "wizard#evidence_upload", via: :all

  # evidence remove
  get "/wizard/evidence/remove", to: "wizard#evidence_remove", via: :all

  # provide contact page
  get  "/wizard/include_contact", to: "wizard#include_contact", via: :all
  post "/wizard/include_contact", to: "wizard#include_contact_submit", via: :all

  # contact page
  get  "/wizard/contact", to: "wizard#contact", via: :all
  post "/wizard/contact", to: "wizard#contact_submit", via: :all

  # review
  get  "/wizard/review", to: "wizard#review", via: :all
  post "/wizard/review", to: "wizard#review_submit", via: :all

  # summary
  get  "/wizard/summary", to: "wizard#summary", via: :all

  # print
  get  "/wizard/print", to: "wizard#print", via: :all

  # not eligible
  get "/wizard/not_eligible", to: "wizard#not_eligible", via: :all


  # resubmit
  get "/resubmit", to: "resubmit#resubmit", via: :all
  post "/resubmit", to: "resubmit#resubmit_submit", via: :all

  # login
  get "/resubmit/login", to: "resubmit#login", via: :all
  post "/resubmit/login", to: "resubmit#login_submit", via: :all

  # login_failed
  get "/resubmit/login_failed", to: "resubmit#login_failed", via: :all

  # confirm
  get "/resubmit/confirm", to: "resubmit#confirm", via: :all
  post "/resubmit/confirm", to: "resubmit#confirm_submit", via: :all

  # resubmitted
  get "/resubmit/resubmitted", to: "resubmit#resubmitted", via: :all
  
  # not found
  get "/resubmit/not_found", to: "resubmit#not_found", via: :all

  # list
  get "/resubmit/list", to: "resubmit#list", via: :all

  # reports
  get "/reports", to: "reports#home", via: :all
  get "/reports/login", to: "reports#login", via: :all
  post "/reports/login", to: "reports#login_submit", via: :all
  get "/reports/logout", to: "reports#logout", via: :all
  get "/reports/menu", to: "reports#menu", via: :all
  get "/reports/report_summary", to: "reports#report_summary", via: :all
  get "/reports/report_summary_percent", to: "reports#report_summary_percent", via: :all

  get "/performance", to: "pages#performance", via: :all
end
