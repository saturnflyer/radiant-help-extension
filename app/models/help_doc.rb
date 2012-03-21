require 'rdoc'

class HelpDoc
  
  def self.find_for(role_type, extension_dir='')
    results = [] 
    if extension_dir.blank?
      Radiant::ExtensionLoader.enabled_extension_paths.each do |ext_path|
        results << help_docs(ext_path, role_type)
      end
    else
      results << help_docs(Radiant::ExtensionPath.for(extension_dir), role_type)
    end
    results.reject(&:blank?).flatten
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
    RDoc::Markup::ToHtml.new.convert(File.read(doc_path))
  end
  
  def self.parsed_markdown(doc_path)
    MarkdownFilter.filter(File.read(doc_path))
  end

  def self.parsed_textile(doc_path)
    ::RedCloth.new(File.read(doc_path)).to_html
  end

  private

  def self.help_docs(ext_path, role_type)
    results = []
    doc_name = ''
    doc_name = "_#{role_type.to_s}" unless role_type.to_s == 'all'
    Dir["#{ext_path}/HELP#{doc_name}*"].each do |ext_help|
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

end