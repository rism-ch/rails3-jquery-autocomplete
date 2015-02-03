module Rails3JQueryAutocomplete
  module Orm
    module Sunspot
      def sunspot_get_autocomplete_order(method, options, model=nil)
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

      def sunspot_get_autocomplete_items(parameters)
        model          = parameters[:model]
        method         = Array(parameters[:method])
        options        = parameters[:options]
        is_full_search = options[:full]
        term           = parameters[:term]
        limit          = get_autocomplete_limit(options)
        order          = sunspot_get_autocomplete_order(method, options)

        s  = model.solr_search do
          fulltext term do
            fields(method)
          end
        end
        
        return s.results
        
      end
    end
  end
end
