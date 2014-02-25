require "active_record/when_change/version"

module ActiveRecord
  module WhenChange
    VALID_OPTIONS = [:from, :to, :if, :unless]
    def self.included(base)
      base.extend ClassMethods
      base.after_initialize do
        @_changed_attrs = {}
        @old_attributes = self.try(:as_json).try(:symbolize_keys).deep_dup || {}
      end
    end

    def when_change attr, config={}, method = nil, &block

      # just return if config is blank or (method or block not given)
      return if config.blank? || (method = nil && !block_given? )
      config.keys.each{|key| Rails.logger.debug("#{key} is not valid options key for ArctiveRecordChanged") if VALID_OPTIONS.included?(key)}

      attribute_changed     = attribute_changed(attr)
      return if attribute_changed == false

      correct_form    = ( config[:from] and ( config[:from] != attribute_changed.old_value ) ? false : true )
      correct_to      = ( config[:to] and ( config[:to] != attribute_changed.new_value ) ? false : true )
      correct_if      = ( config[:if] and ( eval(config[:if]) != true) ? false : true )
      correct_unless  = ( config[:unless] and (eval(config[:unless]) == true) ? false : true )

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
