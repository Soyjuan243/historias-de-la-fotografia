import math

brainrots = [
    {"name": "Common1", "baseIncome": 1, "baseCost": 10},
    {"name": "Common2", "baseIncome": 2, "baseCost": 25},
    {"name": "Common3", "baseIncome": 5, "baseCost": 60},
    {"name": "Common4", "baseIncome": 12, "baseCost": 150},
    {"name": "Common5", "baseIncome": 25, "baseCost": 400},
]

def calculate_stats(base_income, base_cost, level):
    income = math.floor(base_income * (1.5 ** (level - 1)))
    cost = math.floor(base_cost * (1.8 ** (level - 1)))
    return income, cost

def validate():
    print("Progression Validation (Levels 1 to 10):")
    for br in brainrots:
        print(f"\n--- {br['name']} ---")
        for level in range(1, 11):
            income, cost = calculate_stats(br['baseIncome'], br['baseCost'], level)
            roi = cost / income if income > 0 else float('inf')
            print(f"Level {level:2d}: Income=${income:4d}/s, UpgradeCost=${cost:6d}, ROI={roi:.1f}s")

if __name__ == "__main__":
    validate()
