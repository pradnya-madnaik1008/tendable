## Purpose

This is a Ruby-based survey tool where users are prompted to answer a series of Yes/No questions. After each run, a rating is calculated based on the percentage of "Yes" answers, and an average rating is kept across all runs.

## Requirements

- Ruby (version >= 2.6)
- Bundler
- PStore (Ruby standard library)

## Installation

1. Clone the repository:

    ```bash
    cd backend-live-coding-exercise-ruby-final
    ```

2. Install dependencies:

    ```bash
    bundle install
    ```

3. Run the questionnaire:

    ```bash
    ruby questionnaire.rb
    ```

## Usage

1. The program will prompt the user with a series of questions.
2. After answering all questions, the program will display:
    - The rating for that particular session (as a percentage of "Yes" answers).
    - The average rating across all runs.

## Code Explanation

- **PStore** is used to persist answers and scores.
- Each session's rating is calculated based on the number of "Yes" answers and the total number of questions.
- An average rating is maintained across all runs, stored in the `tendable.pstore` file.
