import math

brainrots = [
    {"name": "Common1", "baseIncome": 1, "baseCost": 10},
    {"name": "Common5", "baseIncome": 25, "baseCost": 400},
]

def calculate_stats(base_income, base_cost, level):
    income = math.floor(base_income * (1.5 ** (level - 1)))
    cost = math.floor(base_cost * (1.8 ** (level - 1)))
    return income, cost

def validate():
    print("Progression Validation (Level 1, 50, 100):")
    for br in brainrots:
        print(f"\n--- {br['name']} ---")
        for level in [1, 50, 100]:
            income, cost = calculate_stats(br['baseIncome'], br['baseCost'], level)
            print(f"Level {level:3d}: Income=${income:,.0f}/s, UpgradeCost=${cost:,.0f}")

    print("\nLevel 100 constraint: Checked in BrainrotManager.server.lua")

if __name__ == "__main__":
    validate()
