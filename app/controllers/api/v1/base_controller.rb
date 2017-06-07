class Api::V1::BaseController < ActionController::API
  # Used for User Authentication
  # surprisingly not included by default on API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  def homepage
    render json: { message: 'You Are authenticated!' }, status: :ok
  end

  # Look for a business by business_id, received on URL, and returns the ids of childs
  def business_ids
    @business ||= Business.find(params[:business_id])
    @business.descendant_ids.push(@business.id) if @business
  rescue
    []
  end

  protected

  def authenticate
    authenticate_or_request_with_http_basic do |consumer, password|
      consumer == ENV['CONSUMER_USERNAME'] && password == ENV['CONSUMER_PASSWORD']
    end
  end
end
