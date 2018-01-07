class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  # 変数PERMISSIBLE_ATTRIBUTESに配列[:send_mail]を代入
  PERMISSIBLE_ATTRIBUTES = %i(send_mail)

  protected

  def after_sign_in_path_for(resource)
    '/pages'
  end

  # deviseのストロングパラメーターにカラム追加するメソッドを定義
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: PERMISSIBLE_ATTRIBUTES)
    devise_parameter_sanitizer.permit(:account_update, keys: PERMISSIBLE_ATTRIBUTES)
  end

  # slack通知用メソッド
  def notice_slack(message)
    notifier = Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL'])
    notifier.ping(message)
  end
end
