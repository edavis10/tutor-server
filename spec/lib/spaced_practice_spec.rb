require 'rails_helper'

describe SpacedPractice do
  describe "#pull_unseen_questions" do
    context "successful execution" do
      examples = [
        { description: "returns an empty array when pulling zero questions",
          question_pool: [1,2,3],
          seen_questions: [4,5,6],
          num_questions_to_pull: 0,
          expected: [] },
        { description: "returns an empty array when the question pool is empty",
          question_pool: [],
          seen_questions: [1,2,3],
          num_questions_to_pull: 2,
          expected: [] },
        { description: "pulls questions in the order they appear in the question pool",
          question_pool: [3,1,2],
          seen_questions: [],
          num_questions_to_pull: 3,
          expected: [3,1,2] },
        { description: "skips previously seen questions",
          question_pool: [3,1,2,7,4],
          seen_questions: [3,2],
          num_questions_to_pull: 3,
          expected: [1,7,4] },
        { description: "skips newly-pulled questions",
          question_pool: [3,1,2,1,7,4],
          seen_questions: [3,2],
          num_questions_to_pull: 3,
          expected: [1,7,4] },
        { description: "returns as many questions as possible, even if there are too few",
          question_pool: [3,1,2],
          seen_questions: [1],
          num_questions_to_pull: 3,
          expected: [3,2] },
      ]

      examples.each do |example|
        it example[:description] do
          result = SpacedPractice.pull_unseen_questions(
            example[:question_pool],
            example[:seen_questions],
            example[:num_questions_to_pull])
          expect(result).to eq(example[:expected])
        end
      end
    end

    context "invalid number of questions to pull" do
      it "raises an exception" do
        expect {
          SpacedPractice.pull_unseen_questions([],[],-1)
        }.to raise_error
      end
    end
  end

  describe "#fill_slots" do

    context "successful execution" do
      examples = [
        { description: "assigns no questions when no slot definitions are given",
          slot_defs: {},
          events: [ [10,11,12],
                    [20,21,22] ],
          event_pools: [ [10,11,12,13,14],
                         [20,21,22,23,24] ],
          user_history: [10,21],
          expected: {} },

        { description: "ignores k-ago slot definitions with zero slots",
          slot_defs: { 0 => 0, 1 => 0 },
          events: [ [10,11,12],
                    [20,21,22] ],
          event_pools: [ [10,11,12,13,14],
                         [20,21,22,23,24] ],
          user_history: [10,21],
          expected: {} },

        { description: "handles a 0-ago slot definition (no history)",
          slot_defs: { 0 => 2 },
          events: [],
          event_pools: [ [10,11,12,13,14,15,16],
                         [20,21,22,23,24,25,26] ],
          user_history: [],
          expected: { 0 => [20,21]} },

        { description: "handles a k-ago slot definition (no history)",
          slot_defs: { 2 => 2 },
          events: [ [],
                    [],
                    [] ],
          event_pools: [ [10,11,12,13,14,15,16],
                         [20,21,22,23,24,25,26],
                         [30,31,32,33,34,35,36] ],
          user_history: [],
          expected: { 2 => [10,11]} },

        { description: "ignores k-ago slot definitions before first event (no history)",
          slot_defs: { 3 => 2 },
          events: [ [],
                    [],
                    [] ],
          event_pools: [ [10,11,12,13,14,15,16],
                         [20,21,22,23,24,25,26],
                         [30,31,32,33,34,35,36] ],
          user_history: [],
          expected: { 3 => []} },

        { description: "handles multiple k-ago slot definitions (no history)",
          slot_defs: { 0 => 2,
                       1 => 1,
                       2 => 2,
                       3 => 4},
          events: [ [],
                    [],
                    [] ],
          event_pools: [ [10,11,12,13,14,15,16],
                         [20,21,22,23,24,25,26],
                         [30,31,32,33,34,35,36] ],
          user_history: [],
          expected: { 0 => [30,31],
                      1 => [20],
                      2 => [10,11],
                      3 => [] } },

        { description: "adds questions from past events to user history",
          slot_defs: { 0 => 2,
                       1 => 1,
                       2 => 2,
                       3 => 4},
          events: [ [10,11,12],
                    [20,21],
                    [30,31,32,33] ],
          event_pools: [ [10,11,12,13,14,15,16],
                         [20,21,22,23,24,25,26],
                         [30,31,32,33,34,35,36] ],
          user_history: [],
          expected: { 0 => [34,35],
                      1 => [22],
                      2 => [13,14],
                      3 => [] } },

        { description: "ignores questions in the user history",
          slot_defs: { 0 => 2,
                       1 => 1,
                       2 => 2,
                       3 => 4},
          events: [ [10,11,12],
                    [20,21],
                    [30,31,32,33] ],
          event_pools: [ [10,11,12,13,14,15,16],
                         [20,21,22,23,24,25,26],
                         [30,31,32,33,34,35,36] ],
          user_history: [11,22,35],
          expected: { 0 => [34,36],
                      1 => [23],
                      2 => [13,14],
                      3 => [] } },

        { description: "add slot assigned questions to the user history",
          slot_defs: { 0 => 2,
                       1 => 2},
          events: [ [10,11],
                    [20,21] ],
          event_pools: [ [10,11,12,13,14,15,16],
                         [20,12,21,13,22,23,24,25,26] ],
          user_history: [],
          expected: { 0 => [22,23],
                      1 => [12,13] } },
        ]

      examples.each do |example|
        it example[:description] do
          result = SpacedPractice.fill_slots(
            example[:slot_defs],
            example[:events],
            example[:event_pools],
            example[:user_history])
          expect(result).to eq(example[:expected])
        end
      end
    end

    context "invalid k-ago in slot definitions" do
      it "raises an exception" do
          slot_defs = {  0 => 2,
                        -1 => 1,  # invalid
                         2 => 2,
                         3 => 4 }
          events = []
          event_pools = []
          user_history =  []

          expect {
            SpacedPractice.fill_slots(slot_defs, events, event_pools, user_history)
          }.to raise_error
      end
    end

    context "invalid number of slots in slot definitions" do
      it "raises an exception" do
          slot_defs = { 0 =>  2,
                        1 => -1,  # invalid
                        2 =>  2,
                        3 =>  4 }
          events = []
          event_pools = []
          user_history =  []

          expect {
            SpacedPractice.fill_slots(slot_defs, events, event_pools, user_history)
          }.to raise_error
      end
    end

    context "speed test" do
      it "works" do
          slot_defs = { 0 =>  10,
                        1 =>  10,
                        2 =>  10,
                        3 =>  10 }
          events = [
            [1,3,5,7],
            [1001,1003,1005,1007],
            [2001,2003,2005,2007],
            [3001,3003,3005,3007],
            [4001,4003,4005,4007],
            [5001,5003,5005,5007],
            [6001,6003,6005,6007],
            [7001,7003,7005,7007],
            [8001,8003,8005,8007]
          ]
          event_pools = [
            Array(0..99),
            Array(1000..1990),
            Array(2000..2990),
            Array(3000..3990),
            Array(4000..4990),
            Array(5000..5990),
            Array(6000..6990),
            Array(7000..7990),
            Array(8000..8990)
          ]
          user_history =  [
            Array(8..20),
            Array(1008..1020),
            Array(2008..2020),
            Array(3008..3020)
          ].flatten
          expected = {
            3 => [0, 2,4,6,21,22,23,24,25,26],
            2 => [1000, 1002,1004,1006,1021,1022,1023,1024,1025,1026],
            1 => [2000, 2002,2004,2006,2021,2022,2023,2024,2025,2026],
            0 => [3000, 3002,3004,3006,3021,3022,3023,3024,3025,3026]
          }
          result = SpacedPractice.fill_slots(slot_defs, events, event_pools, user_history)
          expect(result).to eq(expected)
      end
    end

  end
end
