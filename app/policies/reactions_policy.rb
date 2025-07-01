# frozen_string_literal: true

class ReactionsPolicy < ApplicationPolicy
  def create?
    record.participant?(user)
  end

  def destroy?
    create?
  end
end
