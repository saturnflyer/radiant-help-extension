class HelpDoc
  
  def self.find_for(role_type, extension_dir="**")
    results = [] 
    doc_name = ''
    doc_name = "_#{role_type.to_s}" unless role_type.to_s == 'all'
    Dir["#{RAILS_ROOT}/vendor/extensions/#{extension_dir}/HELP#{doc_name}*"].each do |ext_help|
      case role_type.to_s
      when 'all'
        re_matcher = /HELP(\.[\w]+)?$/
      else
        re_matcher = /HELP_[\S]+(\.[\w]+)?$/
      end
      results << ext_help if re_matcher.match(ext_help)
    end
    results
  end
  
  def self.formatted_contents_from(doc_path)
    if doc_path.end_with?('markdown') || doc_path.end_with?('md')
      HelpDoc.parsed_markdown(doc_path)
    elsif doc_path.end_with?('textile')
      HelpDoc.parsed_textile(doc_path)
    else
      HelpDoc.parsed_rdoc(doc_path)
    end
  end
  
  def self.parsed_rdoc(doc_path)
    SM::SimpleMarkup.new.convert(File.read(doc_path), SM::ToHtml.new)
  end
  
  def self.parsed_markdown(doc_path)
    text = File.read(doc_path)
    if defined? RDiscount
      RDiscount.new(text, :smart).to_html
    else
      RubyPants.new(BlueCloth.new(text).to_html).to_html
    end
  end
  
  def self.parsed_textile(doc_path)
    ::RedCloth.new(File.read(doc_path)).to_html
  end
end