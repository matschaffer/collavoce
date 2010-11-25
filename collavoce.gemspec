spec = Gem::Specification.new do |s| 
  s.name = 'collavoce'
  s.version = '0.0.1'
  s.author = 'Mat Schaffer'
  s.email = 'mat@schaffer.me'
  s.homepage = 'http://matschaffer.com'
  # TODO: mention jruby
  s.platform = Gem::Platform::RUBY
  s.summary = 'Powering MIDI through ruby'
  s.files = Dir['lib/**/*']
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc']
end
