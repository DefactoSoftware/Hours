class AuditHistory
  attr_reader :audits, :auditable

  def initialize(history)
    @auditable = history.first.auditable
    @audits = history.map { |a| AuditDecorator.new(a) }
  end
end

class AuditDecorator < SimpleDelegator
  def audit_changes
    if action == "update"
      @audit_changes ||= audited_changes.map { |c| AuditChange::Update.new(c) }
    else
      @audit_changes ||= Array(audited_changes).map { |c| AuditChange::Creation.new(c) }
    end
  end

  def creation?
    action == "create"
  end
end

class AuditChange
  def property
    if association?
      @key[0..-4]
    else
      @key
    end
  end

  def to
    find_association(@to)
  end

  def association?
    @key.last(3) == "_id"
  end

  private

  def property_class
    property.camelize.constantize
  end

  def find_association(id)
    return id unless association?
    return NilAssociation.new unless id
    begin
      property_class.find(id)
    rescue ActiveRecord::RecordNotFound, NameError
      DestroyedAssociation.new(property, id)
    end
  end
end

class AuditChange::Update < AuditChange
  def initialize(audit)
    @key = audit[0]
    @from = audit[1][0]
    @to = audit[1][1]
  end

  def from
    find_association(@from)
  end

  def update?
    true
  end
end

class AuditChange::DestroyedAssociation
  def initialize(klass_name, id)
    @klass_name, @id = klass_name, id
  end

  def destroyed?
    true
  end

  def to_s
    "<# #{@klass_name.camelize} id=#{@id} (not found)>"
  end
end

class AuditChange::NilAssociation
  def initialize
    @name = I18n.t("audits.nothing")
  end

  def destroyed?
    true
  end

  def to_s
    @name
  end
end

class AuditChange::Creation < AuditChange
  def initialize(audit)
    @key = audit[0]
    @to = audit[1]
  end

  def update?
    false
  end
end
