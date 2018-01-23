# -*- encoding: utf-8 -*-
# stub: rails3-jquery-autocomplete 1.0.14 ruby lib

Gem::Specification.new do |s|
  s.name = "rails3-jquery-autocomplete"
  s.version = "1.0.16"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["David Padilla", "Joiey Seeley", "Manu S Ajith"]
  s.date = "2015-01-21"
  s.description = "Use jQuery's autocomplete plugin with Rails 3."
  s.email = "david.padilla@crowdint.com joiey.seeley@gmail.com neo@codingarena.in"
  s.files = ["CHANGELOG.md", "LICENSE", "README.md", "Rakefile", "lib/assets", "lib/assets/javascripts", "lib/assets/javascripts/autocomplete-rails-uncompressed.js", "lib/assets/javascripts/autocomplete-rails.js", "lib/cucumber", "lib/cucumber/autocomplete.rb", "lib/generators", "lib/generators/autocomplete", "lib/generators/autocomplete/install_generator.rb", "lib/generators/autocomplete/uncompressed_generator.rb", "lib/rails3-jquery-autocomplete", "lib/rails3-jquery-autocomplete.rb", "lib/rails3-jquery-autocomplete/autocomplete.rb", "lib/rails3-jquery-autocomplete/form_helper.rb", "lib/rails3-jquery-autocomplete/formtastic.rb", "lib/rails3-jquery-autocomplete/formtastic_plugin.rb", "lib/rails3-jquery-autocomplete/orm", "lib/rails3-jquery-autocomplete/orm.rb", "lib/rails3-jquery-autocomplete/orm/active_record.rb", "lib/rails3-jquery-autocomplete/orm/mongo_mapper.rb", "lib/rails3-jquery-autocomplete/orm/mongoid.rb", "lib/rails3-jquery-autocomplete/orm/solr_terms.rb", "lib/rails3-jquery-autocomplete/rails", "lib/rails3-jquery-autocomplete/rails/engine.rb", "lib/rails3-jquery-autocomplete/simple_form_plugin.rb", "lib/rails3-jquery-autocomplete/version.rb", "lib/steak", "lib/steak/autocomplete.rb", "test/form_helper_test.rb", "test/generators/autocomplete/install_generator_test.rb", "test/generators/autocomplete/uncompressed_generator_test.rb", "test/lib/rails3-jquery-autocomplete/autocomplete_test.rb", "test/lib/rails3-jquery-autocomplete/orm/active_record_test.rb", "test/lib/rails3-jquery-autocomplete/orm/mongo_mapper_test.rb", "test/lib/rails3-jquery-autocomplete/orm/mongoid_test.rb", "test/lib/rails3-jquery-autocomplete/simple_form_plugin_test.rb", "test/lib/rails3-jquery-autocomplete_test.rb", "test/test_helper.rb", "test/view_test_helper.rb"]
  s.homepage = "http://github.com/crowdint/rails3-jquery-autocomplete"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "Use jQuery's autocomplete plugin with Rails 3."
  s.test_files = ["test/form_helper_test.rb", "test/generators/autocomplete/install_generator_test.rb", "test/generators/autocomplete/uncompressed_generator_test.rb", "test/lib/rails3-jquery-autocomplete/autocomplete_test.rb", "test/lib/rails3-jquery-autocomplete/orm/active_record_test.rb", "test/lib/rails3-jquery-autocomplete/orm/mongo_mapper_test.rb", "test/lib/rails3-jquery-autocomplete/orm/mongoid_test.rb", "test/lib/rails3-jquery-autocomplete/simple_form_plugin_test.rb", "test/lib/rails3-jquery-autocomplete_test.rb", "test/test_helper.rb", "test/view_test_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 4.2"])
      s.add_development_dependency(%q<sqlite3-ruby>, [">= 0"])
      s.add_development_dependency(%q<mongoid>, [">= 2.0.0"])
      s.add_development_dependency(%q<mongo_mapper>, [">= 0.9"])
      s.add_development_dependency(%q<mongo>, ["~> 1.6.2"])
      s.add_development_dependency(%q<bson_ext>, ["~> 1.6.2"])
      s.add_development_dependency(%q<guard>, [">= 0"])
      s.add_development_dependency(%q<guard-test>, [">= 0"])
      s.add_development_dependency(%q<test-unit>, ["~> 2.2.0"])
      s.add_development_dependency(%q<shoulda>, ["~> 3.0.1"])
      s.add_development_dependency(%q<uglifier>, [">= 0"])
      s.add_development_dependency(%q<rr>, [">= 0"])
      s.add_development_dependency(%q<simple_form>, ["~> 1.5"])
    else
      s.add_dependency(%q<rails>, [">= 3.0"])
      s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
      s.add_dependency(%q<mongoid>, [">= 2.0.0"])
      s.add_dependency(%q<mongo_mapper>, [">= 0.9"])
      s.add_dependency(%q<mongo>, ["~> 1.6.2"])
      s.add_dependency(%q<bson_ext>, ["~> 1.6.2"])
      s.add_dependency(%q<guard>, [">= 0"])
      s.add_dependency(%q<guard-test>, [">= 0"])
      s.add_dependency(%q<test-unit>, ["~> 2.2.0"])
      s.add_dependency(%q<shoulda>, ["~> 3.0.1"])
      s.add_dependency(%q<uglifier>, [">= 0"])
      s.add_dependency(%q<rr>, [">= 0"])
      s.add_dependency(%q<simple_form>, ["~> 1.5"])
    end
  else
    s.add_dependency(%q<rails>, [">= 3.0"])
    s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
    s.add_dependency(%q<mongoid>, [">= 2.0.0"])
    s.add_dependency(%q<mongo_mapper>, [">= 0.9"])
    s.add_dependency(%q<mongo>, ["~> 1.6.2"])
    s.add_dependency(%q<bson_ext>, ["~> 1.6.2"])
    s.add_dependency(%q<guard>, [">= 0"])
    s.add_dependency(%q<guard-test>, [">= 0"])
    s.add_dependency(%q<test-unit>, ["~> 2.2.0"])
    s.add_dependency(%q<shoulda>, ["~> 3.0.1"])
    s.add_dependency(%q<uglifier>, [">= 0"])
    s.add_dependency(%q<rr>, [">= 0"])
    s.add_dependency(%q<simple_form>, ["~> 1.5"])
  end
end
