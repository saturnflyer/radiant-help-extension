module Admin::HelpHelper
  def help_tree_for(tree, parent_id = nil, head_n = 2)
    head_n = 6 if head_n > 5
    return false if tree.blank?
    ret = "\n<ul>"
    tree.each do |node|
      if node.parent_id == parent_id
        ret << "\n\t<li>"
        ret << content_tag("h#{head_n}",node.topic)
        ret << content_tag('p',node.description)
        ret << help_tree_for(node.children, node.id, head_n + 1) unless node.children.blank?
        ret << "\t</li>\n"
      end
    end
    ret << "</ul>\n"
  end
  
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
  
  def developer_help(&block)
    yield if developer?
  end
  
  def rdoc_extension_dir(rdoc)
    rdoc[/[(\w+)]\/(\w+)\/HELP/, 1]
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