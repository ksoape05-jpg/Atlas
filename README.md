# Atlas

Atlas is a local-first Streamlit life operating system and personal assistant for tracking daily body metrics, nutrition, training consistency, grocery spending, SNAP/EBT budget use, imports from Runna/Strava and Fitbod-style CSVs, weekly progress, financial planning with income/expense tracking, assistant planning, approval-gated drafts, and exportable records.

Everything is stored locally in the `data` folder. There are no paid APIs and no automatic integrations.

## Quick start on Windows

1. Install Python 3.11 or newer from https://www.python.org/downloads/windows/.
2. Open PowerShell in this project folder.
3. Create and activate a virtual environment:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

4. Install dependencies:

```powershell
pip install -r requirements.txt
```

5. Run the app:

```powershell
streamlit run app.py
```

Streamlit will print a local URL, usually `http://localhost:8501`.

## GitHub and VS Code

Atlas uses `https://github.com/ksoape05-jpg/Atlas.git` as its GitHub remote. Open this project folder directly in VS Code:

```powershell
code "C:\Users\Kiegu\OneDrive - Northwestern State University\Documents\New project"
```

To publish the local app baseline to GitHub from your normal Windows account, run:

```powershell
.\scripts\publish_atlas.ps1
```

The script stages source code, tests, sample data, Streamlit config, and VS Code config. It intentionally leaves private local files such as `data/*.csv`, `data/*.json`, `.venv`, caches, backups, and exports out of Git.

## Pages

- **Setup**: Save your name, height, start/goal weight, start waist, goal date, calorie target, protein target, SNAP grocery budget, and planned training days.
- **Daily Check-in**: Add or edit one entry per date for weight, waist, calories, protein, water, steps, sleep, Runna/Fitbod completion, training minutes, mood, soreness, hunger, and notes.
- **Dashboard**: See current weight, change from start, 7-day average weight, calorie/protein averages, training consistency, steps, trend charts, and a coach recommendation.
- **Daily Plan**: Build a local-only assistant plan from fitness, food, recovery, and Walmart-list signals, including evening review prompts, saved plan reviews, and an approval queue for message drafts.
- **Meal Builder**: Estimate a meal from common foods using macros and servings, save the estimate locally without a photo, optionally add totals into Daily Check-in, and build a simple meal-prep plan from local grocery/Walmart data.
- **Meal Photo Log**: Upload a meal photo, estimate macros from common portion presets, save the photo locally, and optionally add the estimate to Daily Check-in.
- **Financial Planner**: Set monthly budgets by category, log expenses with details, track income from part-time jobs, manage bank accounts, import transaction CSVs, and view budget vs actual summaries with charts.
- **Etekcity Scale**: Import VeSync/Etekcity scale CSVs, store body metrics locally, chart scale weight, and sync the first scale reading of each day into Daily Check-in.
- **Runna/Strava Import**: Upload a CSV with flexible column names. The app stores date, source, activity name, distance, moving time, pace, heart rate, calories, and notes.
- **Fitbod Import**: Upload a CSV with flexible column names. The app stores date, source, workout name, exercise, sets, reps, weight, volume, and notes.
- **Grocery + Budget**: Track grocery items, cost, protein, servings, cost per serving, cost per gram of protein, and remaining monthly SNAP budget.
- **Walmart Shopping**: Generate a lazy high-protein weekly grocery plan, build a Walmart Plus pickup/delivery shopping list, open Walmart search links, estimate SNAP spend and protein value, import shopping CSVs, and send purchased items into the grocery log.
- **Training Summary**: Combine Runna/Strava, Fitbod, and Daily Check-in training data into weekly mileage, lifting volume, load warnings, recovery flags, and estimated strength PRs.
- **Weekly Review**: Pick a week and review average weight, weight change, calories, protein, steps, runs, lifts, sleep, and adjustment advice.
- **Data Health**: Check for stale logs, missing weigh-ins, budget issues, import counts, and Walmart list status.
- **Export**: Download all data as Excel, export daily/weekly CSVs, or back up the local data folder as a zip.

## Recommendation rules

The weekly coach logic is intentionally beginner-friendly:

- If weight is dropping about 0.5 to 1.5 lb/week, hold calories steady.
- If weight is flat for two weeks and compliance is good, reduce calories by 150.
- If hunger and soreness are high, improve sleep/recovery before cutting harder.
- If protein is low, prioritize protein before reducing calories.
- If workouts are inconsistent, focus on consistency before changing calories.

The Dashboard also shows a reusable coach snapshot with 7-day and 14-day weight averages, estimated weekly weight-change rate, goal countdown, projected goal timing, and a simple compliance score based on logging, protein, calories, training, and sleep. These calculations live in `utils/coach.py` so the same coaching logic can be reused later in a mobile app.

The Daily Plan page uses `utils/daily_planner.py` to turn the same local data into a deterministic assistant workflow. It can draft a status/check-in message, but Atlas does not send messages, place orders, or touch outside services from that page; drafts are approval-required text for the user to review manually. Drafts can be queued in `data/approval_queue.csv` with context, status, and decision notes so approvals are auditable instead of one-off checkboxes. Evening reviews are saved locally so Atlas can build memory around what actually happened and tomorrow's first action. Recent review memory now feeds back into the next plan as local-only carry-over actions and friction signals, so repeated issues like sleep, food logistics, or schedule pressure become visible without using a cloud service.

Training analytics live in `utils/training.py`. They summarize weekly running mileage, lifting volume, training minutes, recovery flags, and estimated lifting PRs so the Streamlit app is not the only place that understands training logic.

Nutrition helpers live in `utils/nutrition.py`. They calculate meal rows, daily meal totals, grocery protein value rankings, and local meal-prep plans from foods already logged in Grocery + Budget or Walmart Shopping.

## Sample data

The `sample_data` folder includes example CSVs for:

- `daily_log_sample.csv`
- `strava_runna_sample.csv`
- `fitbod_sample.csv`
- `grocery_sample.csv`
- `walmart_shopping_sample.csv`
- `etekcity_scale_sample.csv`

Inside the app sidebar, click **Load sample data** to populate the local `data` folder with a realistic starter set.

## Local data files

The app writes these files as you use it:

- `data/profile.json`
- `data/daily_log.csv`
- `data/runna_strava_imports.csv`
- `data/fitbod_imports.csv`
- `data/grocery_log.csv`
- `data/walmart_shopping_list.csv`
- `data/meal_photo_log.csv`
- `data/meal_photos/`
- `data/etekcity_scale_imports.csv`
- `data/daily_plan_reviews.csv`
- `data/approval_queue.csv`
- `data/financial_expenses.csv`
- `data/financial_budgets.csv`
- `data/financial_income.csv`
- `data/financial_accounts.csv`
- `data/financial_transactions.csv`

## Bank account integrations

Atlas does not connect to banks or use APIs. Instead, export your bank statements as CSV files and import them locally in the Financial Planner > Transactions tab. The app supports common CSV formats with columns like date, description, amount, and category. Transactions are stored privately on your computer and can be categorized for budgeting.

For part-time income tracking, use the Income tab to log paychecks, freelance work, or side gigs separately from bank imports.

## Walmart Plus note

Atlas does not store your Walmart login and does not automate checkout. Walmart's public developer docs focus on seller, supplier, marketplace, and partner APIs rather than a normal personal Walmart Plus cart API. The app uses a safer local workflow: plan your cart, open Walmart search links, place the order in your Walmart account, then mark purchased items so they flow into the grocery budget.

To reset the app, close Streamlit and delete the CSV/JSON files in `data`. Keep `data/.gitkeep` if you are using Git.

## Notes on CSV imports

Runna, Strava, and Fitbod exports can vary. Atlas accepts common column names and tries to normalize them. On the Runna/Strava page, check the distance unit and numeric time unit before saving; Strava bulk exports often use meters for distance and seconds for moving time. Use the **Column matching** expander on import pages to see exactly which uploaded columns were recognized before saving.

For Fitbod exports, the app also recognizes set-order columns such as `Set Order`, `Set Number`, or `Set #`. When Fitbod gives one row per set, Atlas preserves that set order in the `sets` field so repeated sets are not accidentally treated as duplicate imports.

For Etekcity scale data, export or copy your VeSync scale history into a CSV with date/time and weight columns. Atlas accepts common body metric names such as BMI, body fat %, muscle mass, body water %, bone mass, BMR, visceral fat, and metabolic age. Use the Etekcity Scale page to sync the first reading of each day into Daily Check-in.

If a local CSV or `profile.json` is damaged, the app should keep opening and show a warning instead of crashing. Your original file is left in the `data` folder so you can inspect or replace it.

## Tests

Lightweight tests cover core coach calculations:

```powershell
python -m unittest discover -s tests
```

The tests focus on trend detection, plateau detection, compliance scoring, coach next actions, daily plan generation, approval boundaries and audit records, nutrition planning, training load warnings, and estimated strength PRs.

## Future mobile roadmap

Atlas is still a local Streamlit app, but the safest path to mobile is:

1. Keep extracting business logic into `utils/` modules.
2. Replace CSV storage with SQLite models that can sync later.
3. Build a small local API layer around those models.
4. Rebuild the interface in React Native or Flutter.
5. Add optional cloud sync only after the local/private workflow is stable.
