module Rails3JQueryAutocomplete
  module Orm
    module SolrSearch
      def solr_search_get_autocomplete_order(method, options, model=nil)
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

      def solr_search_get_autocomplete_items(parameters)
        model          = parameters[:model]
        method         = Array(parameters[:method])
        options        = parameters[:options]
        is_full_search = options[:full]
        term           = parameters[:term]
        limit          = get_autocomplete_limit(options)
        #order          = sunspot_get_autocomplete_order(method, options)

        solr = Sunspot.session.get_connection
        
        response = solr.get 'select', :params => {
          :"q" => term,
          :"defType" => "edismax",
          :"qf" => "full_name_autocomplete",
          #:"fl" => "*+score",
          :"fq" => "type:Person",
          :"sort" => "src_count_order_is desc"
          #:"q" => "{!term f=full_name_text}#{term.downcase}"
        }

        #ap response
        result = response["response"]["docs"].map do |doc|
        ap doc
        {id: 0, full_name: doc["full_name_autocomplete"], label: doc["full_name_autocomplete"]}
        end
        #ap result
        return result
     
      end
    end
  end
end
