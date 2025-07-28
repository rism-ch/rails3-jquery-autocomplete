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
          #:"sort" => "score desc, #{order_field} desc",
          :"pf" => "#{search_field}^5",
          :"bf" => "log(#{order_field})^2"
        }

        docs = response.dig('response', 'docs') || []

        docs.map do |doc|
          doc = doc.transform_keys(&:to_sym)

          next unless doc[:id_is].present?

          item = {
            id: doc[:id_is],
            value_field => doc[value_field],
            display_value => doc[display_value]
          }

          extra_data.each do |field|
            item[field] = doc[field] if doc.key?(field)
          end

          item
        end.compact

      end
    end
  end
end
