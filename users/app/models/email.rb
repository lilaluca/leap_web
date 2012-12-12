class Email
  include CouchRest::Model::Embeddable

  property :email, String

  validates :email,
    :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/, :message => "needs to be a valid email address"}

  def to_s
    email
  end
end
