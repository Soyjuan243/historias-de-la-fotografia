def calculate_stats(base_income, base_cost, level):
    income = int(base_income * (1.5 ** (level - 1)))
    cost = int(base_cost * (1.8 ** (level - 1)))
    return income, cost

tiers = [
    ("Common1", 1, 10),
    ("CommonGold1", 2, 20),
    ("Uncommon1", 60, 1200),
    ("Rare1", 5000, 150000),
    ("Legendary1", 500000, 50000000)
]

print("Progression Validation (Level 1, 50, 100):")

for name, base_inc, base_cost in tiers:
    print(f"\n--- {name} ---")
    for lvl in [1, 50, 100]:
        inc, cost = calculate_stats(base_inc, base_cost, lvl)
        print(f"Level {lvl:3}: Income=${inc:,.0f}/s, UpgradeCost=${cost:,.0f}")

print("\nLevel 100 constraint: Checked in BrainrotManager.server.lua")
