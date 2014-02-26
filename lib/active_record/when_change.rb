require 'active_record'
require 'active_support/all'
require "active_record/when_change/version"
module ActiveRecord
  module WhenChange
    VALID_OPTIONS = [:from, :to, :if, :unless]
    def self.included(base)
      base.extend ClassMethods
    end

    def when_change attr, config={}, method = nil, &block
      # just return if config is blank or (method or block not given)
      return if self.send("id_was".to_sym).nil? || config.blank? || (method == nil && !block_given? )
      config.keys.each{|key| logger.debug("#{key} is not valid options key for ArctiveRecordChanged") unless VALID_OPTIONS.include?(key)}

      new_attribute         = self.send(attr.to_sym)
      old_attribute         = self.send("#{attr}_was".to_sym)
      return if new_attribute == old_attribute

      correct_form    = ( config[:from] and ( config[:from] != old_attribute ) ? false : true )
      correct_to      = ( config[:to] and ( config[:to] != new_attribute ) ? false : true )
      correct_if      = ( (config[:if] and ( eval(config[:if]) != true ) ) ? false : true )
      correct_unless  = ( (config[:unless] and (eval(config[:unless]) == true) )? false : true )

      if correct_form && correct_to && correct_if && correct_unless
        if block_given?
          block.call(self)
        else
          send(method)
        end
      end
    end

    def attribute_changed(attr)
      @_changed_attrs[attr] ||= ChangedAttributes.new(attr, @old_attributes || {}, self)
    end

    module ClassMethods
      def when_change
      end
    end

    class ChangedAttributes
      attr_reader :attr, :old_attr, :current
      def initialize attr, old_attr, current
        @attr = attr
        @old_attr = old_attr
        @current = current
      end

      def inspect
        old != value
      end

      def old
        old_attr[attr]
      end

      def value
        current.read_attribute attr
      end

      def old_value
        old
      end

      def new_value
        value
      end

    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::WhenChange)
