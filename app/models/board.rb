class Board < ActiveRecord::Base
    has_many :notes
    has_and_belongs_to_many :colors
end
