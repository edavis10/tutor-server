class Book < ActiveRecord::Base
  acts_as_resource allow_nil: true

  sortable_belongs_to :parent_book, on: :number,
                                    class_name: 'Book',
                                    inverse_of: :child_books

  has_many :child_books, class_name: 'Book',
                         foreign_key: :parent_book_id,
                         dependent: :destroy,
                         inverse_of: :parent_book

  has_many :pages, dependent: :destroy, inverse_of: :book

  validates :title, presence: true
end
