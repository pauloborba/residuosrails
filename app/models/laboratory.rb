class Laboratory < ApplicationRecord
    belongs_to :departament
    has_many :residue, dependent: :destroy
    validates :name, presence: true, unique: true
    validates :departament, presence: true
end
