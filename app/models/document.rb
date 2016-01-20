class Document < ActiveRecord::Base
  has_many :revisions, dependent: :destroy
  # def test
  #   binding.pry
  # end
end
