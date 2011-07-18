class Product < ActiveRecord::Base
  # order style
  default_scope :order => 'title'
  # add has_many
  has_many :line_items
  
  before_destroy :ensure_not_referenced_by_any_line_item
  
  # ensure that there are no line items referencing this product
  def ensure_not_referenced_by_any_line_item
    if line_items.count.zero?
      return true
    else
      errors[:base] << "Line Items present"
      return false
    end
  end
  # validation stuff
  validates :title, :description, :image_url, :presence => true          # All items to be filled out are nonblank.
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01} # Price of books are greater than or equal to $0.01.
  validates :title, :uniqueness => true                                  # Title of books should be unique.
  validates :image_url, :format => {                                     # The URL of images loaded should be valid.
            :with    => %r{\.(gif|jpg|png)$}i,
            :message => 'must be a URL for GIF, JPG or PNG image.'}
end
