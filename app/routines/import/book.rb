module Import
  class Book

    lev_routine

    uses_routine Import::CnxResource,
                 as: :cnx_import,
                 translations: { outputs: { type: :verbatim } }

    uses_routine Import::Page, as: :page_import

    protected

    # Recursively imports items in a CNX collection into the given book
    def import_collection(parent_book, hash, options = {})
      book = ::Book.create(parent_book: parent_book,
                           title: hash['title'] || '',
                           path: construct_path(parent_book, options[:path_index]))

      parent_book.child_books << book unless parent_book.nil?

      hash['contents'].each_with_index do |item, i|
        if item['id'] == 'subcol'
          options[:path_index] = i
          import_collection(book, item, options)
        else
          run(:page_import, item['id'], book,
                            options.merge(title: item['title']))
        end
      end

      book
    end

    # Imports and saves a CNX book as a Book
    # Returns the Book object, Resource object and collection JSON as a hash
    def exec(id, options = {})
      run(:cnx_import, id, options.merge(book: true))

      outputs[:book] = import_collection(nil, outputs[:hash]['tree'], options)
      outputs[:book].url = outputs[:url]
      outputs[:book].content = outputs[:content]
      outputs[:book].save

      transfer_errors_from outputs[:book], type: :verbatim
    end

    def construct_path(parent_book, path_index)
      if parent_book.respond_to?(:path) && !parent_book.path.blank?
        path = "#{parent_book.path}"
        path += ".#{path_index + 1}" if path_index
        path
      else
        "#{path_index}"
      end
    end

  end
end
