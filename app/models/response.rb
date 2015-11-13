# == Schema Information
#
# Table name: responses
#
#  id               :integer          not null, primary key
#  answer_choice_id :integer          not null
#  user_id          :integer          not null
#

class Response < ActiveRecord::Base
  validate :respondent_has_not_already_answered_question
  validate :respondent_cannot_respond_to_own_poll


  belongs_to :answer_choice,
    foreign_key: :answer_choice_id,
    primary_key: :id,
    class_name: "AnswerChoice"

  belongs_to :respondent,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: "User"

  has_one :question,
    through: :answer_choice,
    source: :question

    private
    def sibling_responses
      question.responses
    end

    def respondent_has_not_already_answered_question
      # sibling_responses.find_by(user_id).empty?
      if respondent.questions_answered.where(id: question.id).any?
        errors[:user] << "Respondent already answered this question!"
      end
    end

    def respondent_cannot_respond_to_own_poll
      poll_id = question.poll.id
      if respondent.authored_polls.where(id: poll_id).any?
        errors[:user] << "Respondent cannot take his or her own polls."
      end
    end

end
