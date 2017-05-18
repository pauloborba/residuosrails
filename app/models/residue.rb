class Residue < ApplicationRecord
    belongs_to :laboratory
    validates :name, presence: true
    validates :laboratory, presence: true
    validates :weight
end
