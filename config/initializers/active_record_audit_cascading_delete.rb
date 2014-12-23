require 'active_record'

module ActiveRecord
  class Base
    def destroyed_by_association=(association)
      self.audit_comment = 'Deleted automatically because parent ' \
                           "#{association.active_record.name} was deleted"
      super
    end
  end
end
