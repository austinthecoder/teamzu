Sass::Plugin.options[:style] = (Rails.env.development? ? :nested : :compressed)
Sass::Plugin.add_template_location(Rails.root.join('lib', 'sass'))