import tkinter as tk


TOPICS = {
    "Print and comments": (
        "print() shows a message. A comment is a note Python ignores.",
        "print('Hello, world!')\n\n# This is a comment",
    ),
    "Variables": (
        "A variable gives a name to a value so you can use it later.",
        "name = 'Clara'\nage = 36\n\nprint(name)\nprint(age)",
    ),
    "Text and numbers": (
        "Text is a string. Whole numbers are integers; decimals are floats.",
        "message = 'I am learning Python'\ncount = 3\nprice = 2.50",
    ),
    "Getting input": (
        "input() pauses the program so someone can type a response.",
        "name = input('What is your name? ')\nprint('Hello, ' + name)",
    ),
    "Math operators": (
        "Operators let Python do math. % gives the remainder.",
        "print(4 + 2)   # 6\nprint(4 - 2)   # 2\nprint(4 * 2)   # 8\nprint(4 / 2)   # 2.0\nprint(5 % 2)   # 1",
    ),
    "If statements": (
        "if lets your program choose what to do based on a condition.",
        "temperature = 75\n\nif temperature > 70:\n    print('It is warm')\nelse:\n    print('It is cool')",
    ),
    "Loops": (
        "A loop repeats instructions. This for loop prints each name once.",
        "names = ['Pip', 'Moss', 'Pebble']\n\nfor name in names:\n    print(name)",
    ),
    "Functions": (
        "A function is a named set of steps you can use again.",
        "def greet(name):\n    print('Hello, ' + name)\n\ngreet('Clara')",
    ),
    "Lists": (
        "A list stores several values in order. Positions start at 0.",
        "games = ['Mario', 'Kirby', 'WoW']\n\nprint(games[0])\ngames.append('Stardew Valley')",
    ),
    "Dictionaries": (
        "A dictionary stores information as key and value pairs.",
        "player = {\n    'name': 'Clara',\n    'level': 5,\n}\n\nprint(player['name'])",
    ),
}

BG = "#171923"
PANEL = "#222532"
TEXT = "#f4f0ff"
MUTED = "#c5c2d1"
ACCENT = "#e879c5"

root = tk.Tk()
root.title("Python Cheat Sheet")
root.geometry("860x620")
root.minsize(700, 500)
root.configure(bg=BG)

tk.Label(
    root, text="Python Cheat Sheet", bg=BG, fg=TEXT,
    font=("Arial", 22, "bold"), anchor="w", padx=20, pady=14,
).pack(fill="x")
tk.Label(
    root, text="Quick examples for the Python basics.", bg=BG, fg=MUTED,
    font=("Arial", 11), anchor="w", padx=22,
).pack(fill="x")

search_value = tk.StringVar()
search_row = tk.Frame(root, bg=BG, padx=20, pady=14)
search_row.pack(fill="x")
tk.Label(search_row, text="Search", bg=BG, fg=TEXT, font=("Arial", 11)).pack(side="left", padx=(0, 10))
search = tk.Entry(search_row, textvariable=search_value, bg=PANEL, fg=TEXT,
                  insertbackground=TEXT, relief="flat", font=("Arial", 12))
search.pack(side="left", fill="x", expand=True, ipady=7)

body = tk.Frame(root, bg=BG, padx=20, pady=4)
body.pack(fill="both", expand=True)
topics = tk.Listbox(body, width=24, bg=PANEL, fg=TEXT, selectbackground=ACCENT,
                    selectforeground=BG, relief="flat", borderwidth=0,
                    highlightthickness=0, font=("Arial", 11), activestyle="none")
topics.pack(side="left", fill="y", padx=(0, 14))
card = tk.Frame(body, bg=PANEL, padx=18, pady=16)
card.pack(side="left", fill="both", expand=True)
title = tk.Label(card, text="Choose a topic", bg=PANEL, fg=TEXT,
                 font=("Arial", 18, "bold"), anchor="w")
title.pack(fill="x")
description = tk.Label(card, text="", bg=PANEL, fg=MUTED, justify="left",
                       anchor="w", wraplength=520, font=("Arial", 11), pady=10)
description.pack(fill="x")
code = tk.Text(card, bg="#11131b", fg="#f5d2ed", insertbackground=TEXT,
               relief="flat", wrap="none", font=("Menlo", 12), padx=12, pady=12)
code.pack(fill="both", expand=True)
code.configure(state="disabled")
status = tk.StringVar(value="Select a topic to see an explanation and example.")
footer = tk.Frame(card, bg=PANEL, pady=10)
footer.pack(fill="x")
tk.Label(footer, textvariable=status, bg=PANEL, fg=MUTED,
         font=("Arial", 10)).pack(side="left")


def show_topic(name):
    title.configure(text=name)
    description.configure(text=TOPICS[name][0])
    code.configure(state="normal")
    code.delete("1.0", tk.END)
    code.insert("1.0", TOPICS[name][1])
    code.configure(state="disabled")
    status.set("Choose another topic or search above.")


def update_topics(*_):
    term = search_value.get().strip().lower()
    matches = [name for name, (explanation, sample) in TOPICS.items()
               if term in name.lower() or term in explanation.lower() or term in sample.lower()]
    topics.delete(0, tk.END)
    for name in matches:
        topics.insert(tk.END, name)
    if matches:
        topics.selection_set(0)
        show_topic(matches[0])
    else:
        title.configure(text="No matches")
        description.configure(text="Try another word, such as ‘loop’ or ‘text’. ")
        code.configure(state="normal")
        code.delete("1.0", tk.END)
        code.configure(state="disabled")
        status.set("No topics found.")


def select_topic(_event):
    selection = topics.curselection()
    if selection:
        show_topic(topics.get(selection[0]))


def copy_example():
    selection = topics.curselection()
    if selection:
        root.clipboard_clear()
        root.clipboard_append(TOPICS[topics.get(selection[0])][1])
        status.set("Example copied.")


topics.bind("<<ListboxSelect>>", select_topic)
search_value.trace_add("write", update_topics)
tk.Button(footer, text="Copy example", command=copy_example, bg=ACCENT,
          fg=BG, relief="flat", padx=12, pady=6,
          font=("Arial", 10, "bold")).pack(side="right")
update_topics()
search.focus_set()
root.mainloop()
