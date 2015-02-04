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
        #order          = sunspot_get_autocomplete_order(method, options)

        s_total  = model.solr_search do
          fulltext term do
            fields(method.first)
            highlight(method.first)
          end
        end
        
        # Iper dumb hack
        s  = model.solr_search do
          fulltext term do
            fields(method.first)
            highlight(method.first)
          end
          paginate :page => 1, :per_page => s_total.total
        end
        
        dups = []
        s.hits.each do |hit|
          # Each element will be a hash containing only the title of the article.
          # The title key is used by typeahead.js.
          #{ method.first => hit.stored("740a"), :id => 0 }
          #dups = dups | hit.stored(method.first)
           hit.highlights(method.first).each do |h|
             dups << h.format { |word| "#{word}" }
         end
        end
        
        #ap dups.uniq
        
        dups.uniq.map{|e| {method.first => e, :id => 0} }
      end
    end
  end
end
