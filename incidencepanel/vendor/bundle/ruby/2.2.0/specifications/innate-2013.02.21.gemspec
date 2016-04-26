# -*- encoding: utf-8 -*-
# stub: innate 2013.02.21 ruby lib

Gem::Specification.new do |s|
  s.name = "innate"
  s.version = "2013.02.21"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.1") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Michael 'manveru' Fellinger"]
  s.date = "2013-02-21"
  s.description = "Simple, straight-forward base for web-frameworks."
  s.email = "m.fellinger@gmail.com"
  s.homepage = "http://github.com/manveru/innate"
  s.rubyforge_project = "innate"
  s.rubygems_version = "2.4.5.1"
  s.summary = "Powerful web-framework wrapper for Rack."

  s.installed_by_version = "2.4.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, ["~> 1.5.2"])
      s.add_development_dependency(%q<bacon>, ["~> 1.2.0"])
      s.add_development_dependency(%q<rack-test>, ["~> 0.6.2"])
    else
      s.add_dependency(%q<rack>, ["~> 1.5.2"])
      s.add_dependency(%q<bacon>, ["~> 1.2.0"])
      s.add_dependency(%q<rack-test>, ["~> 0.6.2"])
    end
  else
    s.add_dependency(%q<rack>, ["~> 1.5.2"])
    s.add_dependency(%q<bacon>, ["~> 1.2.0"])
    s.add_dependency(%q<rack-test>, ["~> 0.6.2"])
  end
end
