module ButtonsHelper
  
  # def buttons(name = nil, options = {}, &block)
  #   options[:class] = options[:class].to_s.split(' ').push('buttons').uniq.join(' ')
  #   content_tag((name || :div), with_output_buffer(&block), options)
  # end
  # 
  # def button(name, options = {}, html_options = nil)
  #   html_options ||= {}
  #   html_options[:class] = html_options[:class].to_s.split(' ').push('btn').uniq.join(' ')
  #   link_to %(<span><span><b>&nbsp;</b><u>#{name}</u></span></span>).html_safe, options, html_options
  # end
  # 
  # def button_back(name, options = {}, html_options = nil)
  #   html_options ||= {}
  #   html_options[:class] = html_options[:class].to_s.split(' ').push('btn').uniq.join(' ')
  #   link_back %(<span><span><b>&nbsp;</b><u>#{name}</u></span></span>).html_safe, options, html_options
  # end
  # 
  # def button_away(name, options = {}, html_options = nil)
  #   html_options ||= {}
  #   html_options[:class] = html_options[:class].to_s.split(' ').push('btn').uniq.join(' ')
  #   link_away %(<span><span><b>&nbsp;</b><u>#{name}</u></span></span>).html_safe, options, html_options
  # end
  # 
  # def button_to(name, options = {}, html_options = {})
  #   html_options = html_options.stringify_keys
  #   convert_boolean_attributes!(html_options, %w( disabled ))
  # 
  #   method_tag = ''
  #   if (method = html_options.delete('method')) && %w{put delete}.include?(method.to_s)
  #     method_tag = tag('input', :type => 'hidden', :name => '_method', :value => method.to_s)
  #   end
  # 
  #   form_method = method.to_s == 'get' ? 'get' : 'post'
  # 
  #   request_token_tag = ''
  #   if form_method == 'post' && protect_against_forgery?
  #     request_token_tag = tag(:input, :type => "hidden", :name => request_forgery_protection_token.to_s, :value => form_authenticity_token)
  #   end
  # 
  #   if confirm = html_options.delete("confirm")
  #     html_options["onclick"] = "return #{confirm_javascript_function(confirm)};"
  #   end
  # 
  #   url = options.is_a?(String) ? options : self.url_for(options)
  #   name ||= url
  # 
  #   #html_options.merge!("type" => "submit", "value" => name)
  # 
  #   ("<form method=\"#{form_method}\" action=\"#{escape_once url}\" class=\"button-to\"><div>" + method_tag + submit_button(name) + request_token_tag + "</div></form>").html_safe
  # end
  
  def submit_button(name, options = {})
    options.merge!(:type => 'submit')
    options[:class] = options[:class].to_s.split(' ').push('btn').uniq.join(' ')
    content_tag(:button, %(<span><span><b>&nbsp;</b><u>#{name}</u></span></span>).html_safe, options)
  end

end
