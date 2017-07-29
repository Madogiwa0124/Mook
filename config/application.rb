require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Mook
  class Application < Rails::Application
    config.load_defaults 5.1
    # バッチファイルの名前空間
    config.autoload_paths += Dir["#{config.root}/lib"]
  end
end
