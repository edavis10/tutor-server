module SpacedPractice
  def self.fill_slots(slot_defs, events, event_pools, user_history)
    seen_questions = [user_history, events].flatten.uniq

    slot_assignments = slot_defs.sort.reverse.collect do |k_ago, num_slots|
      raise "invalid k-ago value (#{k_ago})" if k_ago < 0
      raise "invalid k-ago number of slots (#{k_ago} => #{num_slots})" if num_slots < 0
      if num_slots == 0
        nil
      else
        slot_assigned_questions = pull_unseen_questions(Array(event_pools[-(k_ago+1)]), seen_questions, num_slots)
        seen_questions.concat slot_assigned_questions
        [k_ago, slot_assigned_questions]
      end
    end

    Hash[slot_assignments.compact]
  end

  def self.pull_unseen_questions(questions, seen_questions, num_questions_to_pull)
    raise "invalid number of question to pull (#{num_questions_to_pull})" if num_questions_to_pull < 0

    unseen_questions = (questions - seen_questions).uniq
    unseen_questions.take(num_questions_to_pull)
  end
end
