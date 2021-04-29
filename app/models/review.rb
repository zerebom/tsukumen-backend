# frozen_string_literal: true
class Review < ApplicationRecord
  belongs_to :shop

  def convert_result_to_kwargs(result:, place_id:)
    kwargs = {}
    name_corespondence = {'author_name': 'reviewer',
                              'text': 'review_text',
                              'rating': 'star'}
    kwargs = {}
      name_corespondence.each do |gcp_name, db_name|
        kwargs[db_name.to_sym] = result[db_name]
    end

  def from_result(result:, place_id:)
    kwargs = self.convert_result_to_kwargs(result, place_id)
    self.reviewer = kwargs['reviewer']
    self.star = kwargs['star']
    self.review_text = kwargs['review_text']
    self
  end

end
