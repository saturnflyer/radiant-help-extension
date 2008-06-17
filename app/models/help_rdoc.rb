class HelpRdoc
  def self.find(which, extension_dir='**')
    results = []
    doc_type = ''
    unless which.to_s == 'all'
      doc_type = "_#{which.to_s}"
    end
    Dir["#{RAILS_ROOT}/vendor/extensions/#{extension_dir}/HELP#{doc_type}.rdoc"].each do |ext|
      results << ext
    end
    if extension_dir == '**'
      results
    else
      results[0]
    end
  end
end