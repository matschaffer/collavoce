Gem::Specification.new do |s|
  s.name    = 'collavoce'
  s.version = '0.0.7a'
  s.summary = 'Powering MIDI through ruby'

  s.author   = 'Mat Schaffer'
  s.email    = 'mat@schaffer.me'
  s.homepage = 'https://github.com/matschaffer/collavoce'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'mocha'

  s.files = Dir['.gemtest', 'Rakefile', 'README.rdoc', 'lib/**/*', 'spec/**/*']
  s.extra_rdoc_files = ['README.rdoc']

  s.rubyforge_project = 'nowarning'
end
