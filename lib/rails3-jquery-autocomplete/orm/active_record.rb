module Rails3JQueryAutocomplete
  module Orm
    module ActiveRecord
      def active_record_get_autocomplete_order(method, options, model=nil)
        order = options[:order]

        table_prefix = model ? "#{model.table_name}." : ""
        order || "LOWER(#{table_prefix}#{method.first}) ASC"
      end

      def active_record_get_autocomplete_items(parameters)
        model   = parameters[:model]
        term    = parameters[:term]
        options = parameters[:options]
        method  = options[:hstore] ? options[:hstore][:method] : Array(parameters[:method])
        scopes  = Array(options[:scopes])
        where   = options[:where]
        limit   = get_autocomplete_limit(options)
        order   = active_record_get_autocomplete_order(method, options, model)


        items = (::Rails::VERSION::MAJOR * 10 + ::Rails::VERSION::MINOR) >= 40 ? model.where(nil) : model.scoped

        scopes.each { |scope| items = items.send(scope) } unless scopes.empty?

        items = items.select(get_autocomplete_select_clause(model, method, options)) unless options[:full_model]
        items = items.where(get_autocomplete_where_clause(model, term, method, options)).
            limit(limit).order(order)
        items = items.where(where) unless where.blank?

        ap items

        items
      end

      def get_autocomplete_select_clause(model, method, options)
        table_name = model.table_name
        (["#{table_name}.#{model.primary_key}", "#{table_name}.#{method.first}"] + (options[:extra_data].blank? ? [] : options[:extra_data]))
      end

      def get_autocomplete_where_clause(model, term, method, options)
        table_name = model.table_name
        # Full search is on by default
        #is_full_search = options[:full]

        # Add a required field to be present in the DB
        required = ""
        if options.include?(:required)
          required = "#{options[:required]} is not null AND"
        end
       
        if options.include?(:string_boundary) && options[:string_boundary] == true
          # Start from the beginning of the string
          query = method.map{|m| ["LOWER(#{table_name}.#{m}) LIKE (?) "] }.join('or ')
          search_term = "#{term.downcase}%"
        elsif options.include?(:exact_match) && options[:exact_match] == true
          # Search for exact match
          query = method.map{|m| ["#{table_name}.#{m} = ? "] }.join('or ')
          search_term = term 
        elsif
          # Search single words in the string
          # Do not use anymore string substitution as it escapes the string
          query = method.map{|m| "#{table_name}.#{m} REGEXP (?) " }.join('or ')
          term_escaped = Regexp.escape(term)
          search_term = "\\b#{term_escaped}.*\\b"
          # The Regex in some case does not match when an exact term is passed
          # we need to add a series of ORs for exact matches
          query_additional = method.map{|m| ["#{table_name}.#{m} = ? "] }.join('or ')
          search_term_additional = term
        end
        if !query_additional
          rep = ["#{required}(#{query})"]
        else
          # make one big query with the OR exact matches
          rep = ["#{required}(#{query}) OR #{query_additional}"]
        end
        ## Important! add all the terms for the query substitution
        ## one for each time the query was repeated
        method.each{|m| rep << search_term}
        # The number of searched terms is the same, so we can iterate again
        # for the same number of times with the additional term.
        method.each{|m| rep << search_term_additional} if search_term_additional
        rep
      end

      def postgres?(model)
        # Figure out if this particular model uses the PostgreSQL adapter
        model.connection.class.to_s.match(/PostgreSQLAdapter/)
      end
    end
  end
end
