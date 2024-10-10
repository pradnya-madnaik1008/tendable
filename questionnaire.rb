require "pstore" # https://github.com/ruby/pstore

STORE_NAME = "tendable.pstore"
store = PStore.new(STORE_NAME)

QUESTIONS = {
  "q1" => "Can you code in Ruby?",
  "q2" => "Can you code in JavaScript?",
  "q3" => "Can you code in Swift?",
  "q4" => "Can you code in Java?",
  "q5" => "Can you code in C#?"
}.freeze

# Load the existing answers and scores from the store
def load_data(store)
  store.transaction do
    store[:answers] ||= []
    store[:scores] ||= []
  end
end

# Persist the user's answers and scores in the PStore
def save_data(store, answers, score)
  store.transaction do
    store[:answers] << answers
    store[:scores] << score
  end
end

# Normalize the answer (accept "Yes", "Y", "No", "N" in any case)
def normalize_answer(answer)
  case answer.strip.downcase
  when "yes", "y"
    true
  when "no", "n"
    false
  else
    nil
  end
end

# Prompt the user for each question and collect their answers
def do_prompt(store)
  answers = {}
  QUESTIONS.each do |key, question|
    print "#{question} (Yes/No): "
    answer = gets.chomp
    answers[key] = normalize_answer(answer)
  end
  answers
end

# Calculate the rating and average rating
def calculate_ratings(answers)
  total_questions = QUESTIONS.length
  yes_count = answers.values.count(true)
  rating = total_questions > 0 ? (100 * yes_count / total_questions) : 0
  rating
end

def do_report(store, answers)
  # Calculate the current rating
  rating = calculate_ratings(answers)

  # Save the answers and the rating to the store
  save_data(store, answers, rating)

  # Report the current rating
  puts "Your rating for this session: #{rating}%"

  # Calculate the average rating across all runs
  store.transaction do
    all_ratings = store[:scores]
    average_rating = all_ratings.empty? ? 0 : (all_ratings.sum / all_ratings.size)
    puts "Your average rating across all sessions: #{average_rating.round(2)}%"
  end
end

# Main execution
load_data(store) # Load any previous data if present
answers = do_prompt(store) # Get answers from user
do_report(store, answers) # Report the rating and average rating
