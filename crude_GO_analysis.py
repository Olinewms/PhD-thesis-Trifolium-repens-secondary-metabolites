from collections import Counter
from goatools.obo_parser import GODag
import pandas as pd
import matplotlib.pyplot as plt

# --- CONFIG ---
go_obo_file = "/home/newol210/macknight_oliver/GOATOOLS_working_dir/go.obo"
go_term_file = "/home/newol210/macknight_oliver/GOATOOLS_working_dir/sig_up_DEGs_none_vs_high_w_eggNOG_GOs_filtered.txt"  # 2-column: gene<TAB>GO:xxxx,GO:xxxx,...
output_csv = "/home/newol210/macknight_oliver/GOATOOLS_working_dir/sig_up_DEGs_none_vs_high_go_term_counts.csv"
plot_file = "/home/newol210/macknight_oliver/GOATOOLS_working_dir/sig_up_DEGs_none_vs_high_go_term_plot.png"
top_n = 20  # Number of GO terms to plot

# --- LOAD GO DAG ---
print("Loading GO DAG...")
go_dag = GODag(go_obo_file)

# --- COUNT GO TERMS ---
print("Counting GO terms...")
go_counts = Counter()
exclude_terms = {"GO:0008150", "GO:0003674", "GO:0005575"}  # Terms to exclude

with open(go_term_file) as f:
    for line in f:
        cols = line.strip().split("\t")
        if len(cols) == 2 and cols[1]:
            go_terms = cols[1].split(",")
            for go in go_terms:
                go = go.strip()  # Clean the GO term
                if go not in exclude_terms:
                    go_counts[go] += 1

# --- BUILD DATAFRAME ---
print("Building GO term table...")
data = []
for go_term, count in go_counts.items():
    if go_term in go_dag:
        name = go_dag[go_term].name
        namespace = go_dag[go_term].namespace
    else:
        name = "NA"
        namespace = "NA"
    data.append((go_term, name, namespace, count))

df = pd.DataFrame(data, columns=["GO_ID", "Name", "Namespace", "Count"])
df.sort_values("Count", ascending=False, inplace=True)

# --- SAVE CSV ---
print(f"Saving to {output_csv}")
df.to_csv(output_csv, index=False)

# --- PLOT ---
print(f"Plotting top {top_n} GO terms...")
df_top = df.head(top_n)
colors = {"biological_process": "lightcoral", "molecular_function": "lightcoral", "cellular_component": "lightcoral"}

plt.figure(figsize=(12, 8))
bars = plt.barh(df_top["Name"], df_top["Count"], color=[colors.get(ns, "gray") for ns in df_top["Namespace"]])
plt.xlabel("GO Term Count")
plt.title(f"Top {top_n} GO Terms in DEGs")
plt.gca().invert_yaxis()  # Highest on top
plt.tight_layout()
plt.savefig(plot_file)
print(f"Plot saved to {plot_file}")
plt.show()

print(f"Number of unique GO terms: {len(df)}")

# --- Count GO terms and check after exclusion ---
print("Counting GO terms after exclusion...")
go_counts = Counter()
exclude_terms = {"GO:0008150", "GO:0003674", "GO:0005575"}

with open(go_term_file) as f:
    for line in f:
        cols = line.strip().split("\t")
        if len(cols) == 2 and cols[1]:
            go_terms = cols[1].split(",")
            for go in go_terms:
                go = go.strip()  # Clean the GO term
                if go not in exclude_terms:
                    go_counts[go] += 1

# --- Check how many unique terms after filtering ---
print(f"Unique GO terms after exclusion: {len(go_counts)}")

# --- Check the distribution of counts ---
print("GO term counts distribution:")
for term, count in go_counts.most_common(10):  # Show the top 10 terms
    print(f"{term}: {count}")

