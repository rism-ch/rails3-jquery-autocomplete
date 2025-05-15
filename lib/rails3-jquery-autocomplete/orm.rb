module Rails3JQueryAutocomplete
  module Orm
    autoload :ActiveRecord , 'rails3-jquery-autocomplete/orm/active_record'
		autoload :Mongoid      , 'rails3-jquery-autocomplete/orm/mongoid'
		autoload :MongoMapper  , 'rails3-jquery-autocomplete/orm/mongo_mapper'
    autoload :SolrTerms     , 'rails3-jquery-autocomplete/orm/solr_terms'
    autoload :SolrSearch, 'rails3-jquery-autocomplete/orm/solr_search'
    autoload :GndAuthorities, 'rails3-jquery-autocomplete/orm/gnd_authorities'
    autoload :GetterFunction, 'rails3-jquery-autocomplete/orm/getter_function'
  end 
end

