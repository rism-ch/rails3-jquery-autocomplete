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

        items
      end

      def get_autocomplete_select_clause(model, method, options)
        table_name = model.table_name
        (["#{table_name}.#{model.primary_key}", "#{table_name}.#{method.first}"] + (options[:extra_data].blank? ? [] : options[:extra_data]))
      end

      def get_autocomplete_where_clause(model, term, method, options)
        table_name = model.table_name
        is_full_search = options[:full]
        like_clause = (postgres?(model) ? 'ILIKE' : 'LIKE')
        if options[:hstore]
          ["LOWER(#{table_name}.#{method} -> '#{options[:hstore][:key]}') LIKE ?", "#{(is_full_search ? '%' : '')}#{term.downcase}%"]
        else
          #["LOWER(#{table_name}.#{method}) #{like_clause} ?", "#{(is_full_search ? '%' : '')}#{term.downcase}%"]
          
          # Add a required field to be present in the DB
          required = ""
          if options.include?(:required)
            required = "#{options[:required]} is not null AND"
          end
          
          query = method.map{|m| "LOWER(#{table_name}.#{m}) #{like_clause} ? " }.join('or ')
          rep = ["#{required}(#{query})"]
          method.map{|m|
            rep << "#{(is_full_search ? '%' : '')}#{term.downcase}%"
          }
          rep
        end
      end

      def postgres?(model)
        # Figure out if this particular model uses the PostgreSQL adapter
        model.connection.class.to_s.match(/PostgreSQLAdapter/)
      end
    end
  end
end
