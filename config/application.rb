require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BeverageTracker
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.eager_load_paths -= Dir[Rails.root.join('lib', 'assets', '**/')]
    config.eager_load_paths -= Dir[Rails.root.join('lib', 'tasks', '**/')]


    config.action_view.sanitized_allowed_tags = ['strong', 'em', 'p', 'ul', 'li']
    config.action_view.sanitized_allowed_protocols = ['http', 'https']

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
