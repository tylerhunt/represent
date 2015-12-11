require_relative 'lib/represent/version'

Gem::Specification.new do |spec|
  spec.name = "represent"
  spec.version = Represent::VERSION
  spec.authors = ['Tyler Hunt']
  spec.email = %w(tyler@tylerhunt.com)
  spec.summary = 'Separate view models and templates for Rails apps.'
  spec.homepage = 'https://github.com/tylerhunt/represent'
  spec.license = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files = `git ls-files -z`
    .split("\x0")
    .reject { |file| file.match(%r{^(test|spec|features)/}) }
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |file| File.basename(file) }
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
