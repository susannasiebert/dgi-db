module ApplicationHelper
  def tx( fragment_id, action = params['action'] )
    EXTERNAL_STRINGS[action][fragment_id].html_safe
  end

  def to( fragment_id, action = params['action'] )
    EXTERNAL_STRINGS[action][fragment_id]
  end

  def icon( icon_name, content = nil, opts = {}, &block )
    if opts.empty? && content.is_a?( Hash )
      opts = content
      content = nil
    end
    content = capture( &block ) if block_given?
    opts[:class] = Array( opts[:class] ).push "icon-#{icon_name}"
    content_tag( :i, content, opts )
  end
end
