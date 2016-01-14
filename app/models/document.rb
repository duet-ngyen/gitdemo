class Document < ActiveRecord::Base
  has_many :revisions
end
