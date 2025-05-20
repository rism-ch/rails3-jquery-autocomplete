module Rails3JQueryAutocomplete
  module Autocomplete
    def self.included(target)
      target.extend Rails3JQueryAutocomplete::Autocomplete::ClassMethods

      target.send :include, Rails3JQueryAutocomplete::Orm::Mongoid if defined?(Mongoid::Document)
      target.send :include, Rails3JQueryAutocomplete::Orm::MongoMapper if defined?(MongoMapper::Document)
      target.send :include, Rails3JQueryAutocomplete::Orm::ActiveRecord
      target.send :include, Rails3JQueryAutocomplete::Orm::SolrTerms
      target.send :include, Rails3JQueryAutocomplete::Orm::SolrSearch
      target.send :include, Rails3JQueryAutocomplete::Orm::GndAuthorities
      target.send :include, Rails3JQueryAutocomplete::Orm::GetterFunction

    end

    #
    # Usage:
    #
    # class ProductsController < Admin::BaseController
    #   autocomplete :brand, :name
    # end
    #
    # This will magically generate an action autocomplete_brand_name, so,
    # don't forget to add it on your routes file
    #
    #   resources :products do
    #      get :autocomplete_brand_name, :on => :collection
    #   end
    #
    # Now, on your view, all you have to do is have a text field like:
    #
    #   f.text_field :brand_name, :autocomplete => autocomplete_brand_name_products_path
    #
    #
    # Yajl is used by default to encode results, if you want to use a different encoder
    # you can specify your custom encoder via block
    #
    # class ProductsController < Admin::BaseController
    #   autocomplete :brand, :name do |items|
    #     CustomJSONEncoder.encode(items)
    #   end
    # end
    #
    module ClassMethods
      def autocomplete(object, method, options = {}, &block)

        method_first =  method.is_a?(Array) ? method.first : method

        define_method("get_prefix") do |model, options|
          if defined?(Mongoid::Document) && model.include?(Mongoid::Document)
            'mongoid'
          elsif defined?(MongoMapper::Document) && model.include?(MongoMapper::Document)
            'mongo_mapper'
          elsif options.include?(:solr) && options[:solr] == true
            'solr_terms'
          elsif options.include?(:solr_search) && options[:solr_search] == true
            'solr_search'
          elsif options.include?(:gnd) && options[:gnd] == true
            'gnd_authorities'
          elsif options.include?(:getter_function)
            'getter_function'
          else
            'active_record'
          end

        end

        define_method("get_autocomplete_order") do |method, options, model=nil|
          method("#{get_prefix(get_object(options[:class_name] || object))}_get_autocomplete_order").call(method, options, model)
        end

        define_method("get_autocomplete_items") do |parameters|
          method("#{get_prefix(get_object(options[:class_name] || object), parameters[:options])}_get_autocomplete_items").call(parameters)
        end

        define_method("autocomplete_#{object}_#{method_first}") do

          method = options[:column_name] if options.has_key?(:column_name)

          term = params[:term]
          if term && !term.blank?
            #allow specifying fully qualified class name for model object
            class_name = options[:class_name] || object
            items = get_autocomplete_items(:model => get_object(class_name), \
              :options => options, :term => term, :method => method)
          else
            items = {}
          end

          render :json => json_for_autocomplete(items, options[:display_value] ||= method_first, options[:extra_data], options[:value_field] ||= method_first, &block), root: false
        end
      end
    end

    # Returns a limit that will be used on the query
    def get_autocomplete_limit(options)
      options[:limit] ||= 20
    end

    # Returns parameter model_sym as a constant
    #
    #   get_object(:actor)
    #   # returns a Actor constant supposing it is already defined
    #
    def get_object(model_sym)
      begin
        object = model_sym.to_s.camelize.constantize
      rescue NameError
        # If it is not an object, still continue and don't die
        object = model_sym.to_s.camelize
      end
    end

    #
    # Returns a hash with three keys actually used by the Autocomplete jQuery-ui
    # Can be overriden to show whatever you like
    # Hash also includes a key/value pair for each method in extra_data
    #
    def json_for_autocomplete(items, method, extra_data=[], default_value)
      items = items.collect do |in_item|
        
        # Make sure the keys are all symb
        if in_item.is_a?(Hash)
          item = in_item.transform_keys(&:to_sym)
        else
          item = in_item.attributes.symbolize_keys
        end
        
        if item.is_a?(Hash)
          hash = {"id" => item[:id], "label" => item[method], "value" => item[default_value]}
        else
          hash = {"id" => item.id.to_s, "label" => item.send(method), "value" => item.send(default_value)}
        end
        extra_data.each do |datum|
          # is this a method in the object?
          if item.respond_to? datum
            hash[datum] = item.send(datum)
          else
            # in this case we assume it is a key to a hash
            hash[datum] = item[datum]
          end
        end if extra_data
        # TODO: Come back to remove this if clause when test suite is better
        hash
      end
      if block_given?
        yield(items)
      else
        items
      end
    end
  end
end
