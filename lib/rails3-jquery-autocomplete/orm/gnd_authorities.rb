module Rails3JQueryAutocomplete
  module Orm
    module GndAuthorities
      def gnd_authorities_get_autocomplete_order(method, options, model=nil)
        [[method.to_sym, :asc]]
      end

      def gnd_authorities_get_autocomplete_items(parameters)
        model          = parameters[:model]
        method         = Array(parameters[:method])
        options        = parameters[:options]
        #is_full_search = options[:full]
        term           = parameters[:term]
        limit          = get_autocomplete_limit(options)
        #order          = sunspot_get_autocomplete_order(method, options)
        
        result = GND::Interface.autocomplete(term, method, limit, options)
      end
    end
  end
end
