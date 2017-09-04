class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  # before_actionで下で定義したメソッドを実行
  before_action :configure_permitted_parameters, if: :devise_controller?
  #変数PERMISSIBLE_ATTRIBUTESに配列[:send_mail]を代入
  PERMISSIBLE_ATTRIBUTES = %i(send_mail)

  protected

  #deviseのストロングパラメーターにカラム追加するメソッドを定義
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: PERMISSIBLE_ATTRIBUTES)
    devise_parameter_sanitizer.permit(:account_update, keys: PERMISSIBLE_ATTRIBUTES)
  end
end
