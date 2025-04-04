# Configure Rails HTML sanitizer
Rails.application.config.action_view.sanitizer_vendor = Rails::HTML::Sanitizer

# If you were previously modifying allowed protocols, use this approach instead:
Rails.application.config.action_view.sanitized_allowed_tags = ['strong', 'em', 'b', 'i', 'p', 'code', 'pre', 'tt', 'samp', 'kbd', 'var', 'sub', 'sup', 'dfn', 'cite', 'big', 'small', 'address', 'hr', 'br', 'div', 'span', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'ul', 'ol', 'li', 'dl', 'dt', 'dd', 'abbr', 'acronym', 'a', 'img', 'blockquote', 'del', 'ins']

Rails.application.config.action_view.sanitized_allowed_attributes = ['href', 'src', 'width', 'height', 'alt', 'cite', 'datetime', 'title', 'class', 'name', 'xml:lang', 'abbr', 'style', 'target']

# If you specifically need to configure allowed protocols
class CustomSanitizer < Rails::HTML5::Sanitizer
  def allowed_protocols
    super + ['your_custom_protocol']  # Add any custom protocols you need
  end
end

# Register your custom sanitizer
ActionView::Helpers::SanitizeHelper.sanitizer_vendor = CustomSanitizer.new