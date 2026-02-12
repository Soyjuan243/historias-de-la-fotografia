def calculate_stats(base_income, base_cost, level):
    income = int(base_income * (1.5 ** (level - 1)))
    cost = int(base_cost * (1.8 ** (level - 1)))
    return income, cost

tiers = [
    ("Common1", 1, 10),
    ("CommonGold1", 2, 20),
    ("Uncommon1", 30, 1800),
    ("Rare1", 600, 150000),
    ("Legendary1", 15000, 15000000),
    ("Secret1", 1000000, 5000000000)
]

print("Balanced Progression Validation (Level 1, 50, 100):")

for name, base_inc, base_cost in tiers:
    print(f"\n--- {name} ---")
    for lvl in [1, 50, 100]:
        inc, cost = calculate_stats(base_inc, base_cost, lvl)
        # Use scientific notation for very large numbers to keep it readable
        if inc > 1e15:
            inc_str = f"${inc:.2e}"
        else:
            inc_str = f"${inc:,.0f}"

        if cost > 1e15:
            cost_str = f"${cost:.2e}"
        else:
            cost_str = f"${cost:,.0f}"

        print(f"Level {lvl:3}: Income={inc_str}/s, UpgradeCost={cost_str}")

print("\nLevel 100 constraint: Checked in BrainrotManager.server.lua")
