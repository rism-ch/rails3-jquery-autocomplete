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
        
        getter_options = options.include?(:getter_options) ? options[:getter_options] : {}
        # Override the method name so we can change the autocomplete name
        record_field = options.include?(:record_field) ? options[:record_field] : method
        results = send(options[:getter_function], term, getter_options)
        
        return results.map do |r| 
          label = r.send(:getter_function_autocomplete_label, r)
          {id: r.id, :"#{method}" => r[record_field], label: label}
        end
      end
    end
  end
end
