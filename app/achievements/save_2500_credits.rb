class Save2500Credits < Achievement
  @queue = :high

  triggered_on :end_turn

  class << self
    def display_name
      'Profiteer'
    end

    def description
      'Save 2,500 credits.'
    end

    def enqueue_check!(payload)
      Resque.enqueue(self, payload[:command].to_json_hash)
    end

    def grant?(command)
      credit_threshold = 2500
      command = command.with_indifferent_access
      info = command[:ivars]

      if info[:new_current_player_id].present? and info[:credits_earned] < credit_threshold
        if info[:new_credits_amount] >= credit_threshold
          user = User.find(info[:new_current_player_id])
          return grant_return(user.achieved!(self), user)
        end
      end

      return grant_return(false)
    end
  end
end
