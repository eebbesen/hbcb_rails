class Posting < ActiveRecord::Base
  belongs_to :bio

  filterrific default_filter_params: { sorted_by: 'created_at_desc' },
              available_filters: %w[
                sorted_by
                search_query
              ]

  scope :search_query, lambda {|query|
    return nil if query.blank?
    # condition query, parse into individual keywords
    terms = query.downcase.split(/\s+/)
    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = terms.map { |e|
      (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conditions = 3
    where(
      terms.map {
        or_clauses = [
          "LOWER(postings.position) LIKE ?",
          "LOWER(postings.post) LIKE ?",
          "LOWER(postings.district) LIKE ?"
        ].join(' OR ')
        "(#{ or_clauses })"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conditions }.flatten
    )
  }

  scope :sorted_by, lambda { |sort_option|
  }

  def self.options_for_sorted_by
    []
  end


end
