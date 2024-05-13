module Rails3JQueryAutocomplete
  module Orm
    module SolrTerms
      def solr_terms_get_autocomplete_order(method, options, model=nil)
        order = options[:order]
        if order
          order.split(',').collect do |fields|
            sfields = fields.split
            [sfields[0].downcase.to_sym, sfields[1].downcase.to_sym]
          end
        else
          [[method.to_sym, :asc]]
        end
      end

      def solr_terms_get_autocomplete_items(parameters)
        model          = parameters[:model]
        method         = Array(parameters[:method])
        options        = parameters[:options]
        is_full_search = options[:full]
        term           = parameters[:term]
        limit          = get_autocomplete_limit(options)
        #order          = sunspot_get_autocomplete_order(method, options)

        solr = Sunspot.session.get_connection
        #response = solr.get 'terms', :params => {:"terms.fl" => method.first, :"terms.limit" => 30, :"terms.prefix" => term}
        
        # facet.contains tolerates [], and the other chars are stripped by default
        #term = term.gsub(/([\[\]\{\}\(\)\+\-\&\|\!\^\~\*\?\:\"\\])/, '\\\\\1')
        
        response = solr.get 'select', :params => {
          :"facet.field" => method.first, 
          :"facet.contains" => term, 
          :"facet.contains.ignoreCase" => true,
          :"facet" => true, 
          :"q" => "#{method.first}:*", #{term}*", ## NOTE we use facet.contains noew for the catual filtering
          :"facet.mincount" => "1", 
          :"facet.limit" => 30, 
          :"fl" => "id", 
          :rows => "0"}
        
        # Example response:
        #{
        #  'terms'=>{
        #    '740a_sm'=>[
        #      'Line 1',10,
        #      'Line 2',1]}}
        #
        # It is an array alternating the term and the hits
        # Use the Array splat operator to convert a list
        # of subseques values separated by commas to 
        # key/value pairs
        # a,1,b,2 becomes {a => 1, b => 2}
        #found_terms = Hash[*response["terms"][method.first]].keys
        
        #["facet_counts"]["facet_fields"
        
=begin
        # This is the old version, which returns only the term
        found_terms = Hash[*response["facet_counts"]["facet_fields"][method.first]].keys

        # Fake it as a normal DB response
        found_terms.map{|e| {method.first => e, :id => 0} }
=end
        # Trasform the results in a hash, so you get them and hits
        # 'line 1' => 10
        items = Hash[*response["facet_counts"]["facet_fields"][method.first]]
        
        # Return a label with the hits
        # This works with :display_value => :label
        # in the declaration
        return items.map do |k, v|
          {id: 0, method.first => k, label: "#{k} (#{v})"}
        end
        
      end
    end
  end
end
