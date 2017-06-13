class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def generate_prediction
    render('generate_prediction')
  end
  
  def generate_deps
    render('generate_deps')
  end
end
