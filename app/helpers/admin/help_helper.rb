module Admin::HelpHelper
  def help_tree_for(tree, parent_id = nil)
    return false if tree.blank?
    head_n = 2 || head_n
    head_n = 6 if head_n > 5
    ret = "\n<ul>"
    tree.each do |node|
      if node.parent_id == parent_id
        ret += "\n\t<li>"
        ret << content_tag("h#{head_n}",node.topic)
        ret << content_tag('p',node.description)
        ret += help_tree_for(node.children, node.id) unless node.children.blank?
        ret += "\t</li>\n"
      end
    end
    ret += "</ul>\n"
  end
end