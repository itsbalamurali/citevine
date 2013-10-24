class Message

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :email, :body

  validates :email, :body, :presence => {:message => 'Please fill all fields.'}
  validates :email, :format => { :with => %r{.+@.+\..+}, :message => 'Email address must be valid.'}, :allow_blank => true
  
  def initialize(attributes = {})
    attributes.each do |email, value|
      send("#{email}=", value)
    end
  end

  def persisted?
    false
  end

end