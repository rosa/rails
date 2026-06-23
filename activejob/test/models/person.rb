# frozen_string_literal: true

class Person
  class RecordNotFound < StandardError; end
  class BackendError < StandardError; end

  include GlobalID::Identification

  attr_reader :id

  def self.find(id)
    raise RecordNotFound.new("Cannot find person with ID=404") if id.to_i == 404
    raise BackendError.new("backend unavailable") if id.to_i == 500
    new(id)
  end

  def self.where(conditions)
    ids = Array(conditions[:id])
    ids.filter_map do |id|
      case id.to_i
      when 404 then nil
      when 500 then raise BackendError.new("backend unavailable")
      else new(id)
      end
    end
  end

  def initialize(id)
    @id = id
  end

  def ==(other_person)
    other_person.is_a?(Person) && id.to_s == other_person.id.to_s
  end
end
