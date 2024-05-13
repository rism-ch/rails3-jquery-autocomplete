module Rails3JQueryAutocomplete
  module Orm
    module GetterFunction
      def getter_function_get_autocomplete_order(method, options, model=nil)
        [[method.to_sym, :asc]]
      end

      def getter_function_get_autocomplete_items(parameters)
        model          = parameters[:model]
        method         = parameters[:method]
        options        = parameters[:options]
        #is_full_search = options[:full]
        term           = parameters[:term]
        limit          = get_autocomplete_limit(options)
        #order          = sunspot_get_autocomplete_order(method, options)
        
        results = send(options[:getter_function], term)

        return results.map do |r| 
          label = r.send(:getter_function_autocomplete_label, r)
          {id: r.id, title: r.title, label: label}
        end
      end
    end
  end
end
