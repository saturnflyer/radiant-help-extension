module Admin::HelpHelper
  # This code doesn't work...
  # ready for more roles when they appear in Radiant
  # %{admin developer}.each do |role|
  #   define_method("#{role}_help") do |block|
  #      yield block if "#{role}?"
  #   end
  # end
  
  def admin_help(&block)
    yield if admin?
  end
  
  def designer_help(&block)
    yield if designer?
  end
  
  def doc_extension_dir(doc)
    dir = doc[/[(\w+)]\/(\w+)\/HELP/, 1] # vendored
    if dir.blank?                        # gemified
      path_ary = doc.split('/')
      dir = path_ary[path_ary.count-2].sub('radiant-','').sub(/-extension-.*/,'')
    end
    dir
  end
  
  def all_tags
    tags = {}
    page_classes = [Page.descendants, Page].flatten
    page_classes.each do |page_class| 
      page_class.tag_descriptions.each do |name, details| 
        if tags[name]
          tags[name][:classes] << page_class.to_s
        else
          tags[name] = {:description => details, :classes => [page_class.to_s]}
        end
      end
    end
    tags
  end
end