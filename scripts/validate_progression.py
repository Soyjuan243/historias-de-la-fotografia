def calculate_stats(base_income, base_cost, level):
    # Nuevos factores: 1.1 para ingreso, 1.12 para costo
    income = int(base_income * (1.1 ** (level - 1)))
    cost = int(base_cost * (1.12 ** (level - 1)))
    return income, cost

tiers = [
    ("Common1", 1, 10),
    ("CommonGold1", 2, 20),
    ("Uncommon1", 25, 1000),
    ("Rare1", 500, 80000),
    ("Legendary1", 10000, 5000000),
    ("Secret1", 500000, 1000000000)
]

print("REBALANCED Progression Validation (Level 1, 50, 100):")

for name, base_inc, base_cost in tiers:
    print(f"\n--- {name} ---")
    for lvl in [1, 50, 100]:
        inc, cost = calculate_stats(base_inc, base_cost, lvl)

        if inc > 1e15:
            inc_str = f"${inc:.2e}"
        else:
            inc_str = f"${inc:,.0f}"

        if cost > 1e15:
            cost_str = f"${cost:.2e}"
        else:
            cost_str = f"${cost:,.0f}"

        print(f"Level {lvl:3}: Income={inc_str}/s, UpgradeCost={cost_str}")

print("\nFactors used: Income x1.1, Cost x1.12 per level")
print("Level 100 constraint: Checked in BrainrotManager.server.lua")
