class Document < ActiveRecord::Base
  has_many :revisions, dependent: :destroy
end
