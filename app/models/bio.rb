class Bio < ActiveRecord::Base
  has_many :postings

  def formatted_name
    "#{first_name} #{middle_name} #{last_name}".split(' ').map(&:capitalize)
  end
end
