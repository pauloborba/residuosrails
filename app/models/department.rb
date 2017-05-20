class Department < ApplicationRecord
    has_many :laboratories, dependent: :destroy
    validates :name, presence: true
end
