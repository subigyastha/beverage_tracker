# config/initializers/html_sanitizer_fix.rb

module ActionView
  module Helpers
    module SanitizeHelper
      module ClassMethods
        private
          # Monkey patch the deprecate_option method to use the new API
          def deprecate_option(name)
            ActiveSupport::Deprecation.new.warn("The #{name} option is deprecated " \
              "and has no effect. Until Rails 5 the old behavior can still be " \
              "installed. To do this add the `rails-deprecated-sanitizer` to " \
              "your Gemfile. Consult the Rails 4.2 upgrade guide for more information.")
          end
      end
    end
  end
end