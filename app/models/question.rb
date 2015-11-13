# == Schema Information
#
# Table name: questions
#
#  id      :integer          not null, primary key
#  text    :string           not null
#  poll_id :integer          not null
#

class Question < ActiveRecord::Base
  has_many :answer_choices,
    foreign_key: :question_id,
    primary_key: :id,
    class_name: "AnswerChoice"

  belongs_to :poll,
    foreign_key: :poll_id,
    primary_key: :id,
    class_name: "Poll"

  has_many :responses,
    through: :answer_choices,
    source: :responses

  def results
    results = {}
    # answer_choices.each do |choice| # for N+1 queries
    # answer_choices.includes(:responses).each do |choice|
    #   # results[choice.text] = choice.responses.count # for N+1 queries
    #   results[choice.text] = choice.responses.length
    # end
    answer_choices.joins("LEFT OUTER JOIN responses ON answer_choices.id = responses.answer_choice_id").select("answer_choices.text, COUNT(answer_choices.id) AS votes").group("answer_choices.id").each do |choice|
      results[choice.text] = choice.votes
    end
    # debugger
    results
  end
end
