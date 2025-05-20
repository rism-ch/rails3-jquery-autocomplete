module Rails3JQueryAutocomplete
  module Orm
    module SolrSearch
      def solr_search_get_autocomplete_order(method, options, model=nil)
       nil
      end

      def solr_search_get_autocomplete_items(parameters)
        model          = parameters[:model]
        method         = Array(parameters[:method])
        options        = parameters[:options]
        is_full_search = options[:full]
        value_field    = options[:value_field]
        display_value  = options[:display_value]
        extra_data     = options[:extra_data]
        search_field   = options[:search_field]
        order_field    = options[:order_field]
        term           = parameters[:term]
        limit          = get_autocomplete_limit(options)
        #order          = sunspot_get_autocomplete_order(method, options)

        solr = Sunspot.session.get_connection
        response = solr.get 'select', :params => {
          :"q" => term,
          :"defType" => "edismax",
          :"qf" => "#{search_field}",
          :"fq" => "type:#{model.to_s}",
          :"sort" => "#{order_field} desc"
        }

        result = response["response"]["docs"].map do |doc_str|
          doc = doc_str.transform_keys(&:to_sym)
          resp = {id: doc[:id_is], value_field => doc[value_field], display_value => doc[display_value]}
          extra_data.each {|ex| resp[ex] = doc[ex] if doc.include?(ex)}

          resp
        end
        return result

      end
    end
  end
end
