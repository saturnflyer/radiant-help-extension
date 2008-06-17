class HelpRdoc
  def self.find(which, extension_dir='**')
    results = []
    rdoc_type = ""
    unless which == 'all'
      rdoc_type = "_#{which}"
    end
    [:admin, :developer, :all].each do |type|
      if which.to_sym == type
        Dir["#{RAILS_ROOT}/vendor/extensions/#{extension_dir}/HELP#{rdoc_type}.rdoc"].each do |ext|
          results << ext
        end
      end
    end
    if extension_dir == '**'
      results
    else
      results[0]
    end
  end
end