Gem::Specification.new do |s|
  s.name        	= 'data-writer'
  s.version     	= '0.9.0'
  s.date        	= '2012-07-15'
  s.summary     	= "Allows you to write to DATA"
  s.description 	= "Normally you can only read from DATA but with data-writer you can also write to it. This allows you to easily persist data in a source file."
  s.authors     	= ["Kalle Lindström"]
  s.email       	= ["lindstrom.kalle@gmail.com"]
  s.homepage    	= "https://github.com/kl/data-writer"
  s.files       	= %w[lib/data-writer.rb README.md data-writer.gemspec Gemfile]
  s.require_paths = ['lib']
  s.has_rdoc 		  = false

  s.add_development_dependency('rake')
  s.add_development_dependency('minitest')
end