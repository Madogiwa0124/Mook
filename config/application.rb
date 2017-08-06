require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Mook
  class Application < Rails::Application
    config.load_defaults 5.1
    # 言語を日本語に変更
    config.i18n.default_locale = :ja
    # バッチファイルの名前空間
    config.autoload_paths += Dir["#{config.root}/lib"]
    # タイムゾーンを日本時間に変更
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local
    # 不要なファイルは生成しないように変更
    config.generators do |g|
      g.assets      false # scss,js
      g.helper      false # XX_helper.rb
    end
    # メッセージ形式を変更
    config.action_view.field_error_proc = proc { |html_tag, instance| html_tag }
  end
end
