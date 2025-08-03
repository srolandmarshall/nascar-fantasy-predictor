# NASCAR Fantasy Optimizer

This Ruby project helps optimize fantasy NASCAR lineups for a given race, using driver stats and salary constraints.

## Features

- Imports driver data from CSV
- Models drivers, races, and predictions
- Calculates optimal 6-driver lineup under a salary cap
- Considers average points per game and position differential potential (track-specific weighting)

## Usage

1. **Install Ruby (see `.ruby-version` for version)**
2. **Install dependencies:**

```
bundle install
```

3. **Run optimizer:**

```
ruby run.rb
```

## File Overview

- `run.rb` — Main entry point; loads drivers and runs prediction
- `lib/driver.rb` — Driver model (name, salary, stats, scoring)
- `lib/race.rb` — Race logic, salary cap, lineup optimization
- `lib/prediction.rb` — Formats and displays lineup predictions
- `data/iowa-corn.csv` — Driver data for Iowa Speedway race
- `.ruby-version` — Ruby version requirement
- `Gemfile` — Gem dependencies

## Customization

- To use a different race, update the CSV and track name in `run.rb`
- Adjust salary cap or differential weights in `lib/race.rb`

## Output

The optimizer prints the best lineup, total salary, and combined score.

---

_For questions or improvements, open an issue or submit a pull request._
