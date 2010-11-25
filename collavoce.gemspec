$spec = Gem::Specification.new do |s|
  s.name    = 'collavoce'
  s.version = '0.0.1'
  s.summary = 'Powering MIDI through ruby'

  s.author   = 'Mat Schaffer'
  s.email    = 'mat@schaffer.me'
  s.homepage = 'https://github.com/matschaffer/collavoce'

  s.add_development_dependency 'rspec'

  s.files = Dir['README.rdoc', 'lib/**/*']
  s.extra_rdoc_files = ['README.rdoc']

  s.rubyforge_project = 'nowarning'
end
