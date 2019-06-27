lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "campaign/discrepancies/version"

Gem::Specification.new do |spec|
  spec.name          = "campaign-discrepancies"
  spec.version       = Campaign::Discrepancies::VERSION
  spec.authors       = ["Mark"]
  spec.email         = ["markhimel.cs@gmail.com"]

  spec.summary       = "A simple campaign discrepancy detector"
  spec.description   = "A very simple campaign discrepancy detector gem where it'll track down the difference between the local and remote campaigns. It'll very simple track down by comparing the status and the description of the same campaign that both in local and in remote."
  spec.homepage      = 'https://github.com/mark-himel/campaign-discrepancies'
  spec.summary       = 'A gem to identify discrepancies among local and remote campaigns'
  spec.license       = "MIT"
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'activerecord', '~> 5.0', '>= 5.0.0.1'
  spec.add_development_dependency 'dotenv', '~> 2.7', '>= 2.7.4'
  spec.add_development_dependency 'sqlite3'
end
