Gem::Specification.new do |s|
  s.name        = 'respond_with_chart'
  s.version     = '0.1.0'
  s.authors     = ['Nathan']
  s.summary     = 'Respond with JSON or PNG chart from the same action'
  s.description = 'A Rails Railtie that adds a json_or_png_chart helper to controllers. ' \
                  'Returns raw JSON for .json requests and a Gruff-rendered PNG for .png requests.'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 3.0'

  s.files = Dir['lib/**/*', 'LICENSE', 'README.md']

  s.add_dependency 'actionpack', '>= 6.0'
  s.add_dependency 'gruff',     '>= 0.23'
  s.add_dependency 'railties',  '>= 6.0'

  s.add_development_dependency 'minitest', '~> 5.0'
  s.add_development_dependency 'rake'
end
