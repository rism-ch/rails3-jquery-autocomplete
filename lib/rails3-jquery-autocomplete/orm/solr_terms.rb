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
        response = solr.get 'terms', :params => {:"terms.fl" => method.first, :"terms.limit" => 30, :"terms.prefix" => term}
        
        
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
        found_terms = Hash[*response["terms"][method.first]].keys
        
        # Fake it as a normal DB response
        found_terms.map{|e| {method.first => e, :id => 0} }
      end
    end
  end
end
