import gen_bot

crawl = "../crawls/Teddy.Spiders.PileaPerge_2020_12_06_13_26_18_032518.jl"

# Example format:
#
# {"url":"url",
#  "properties":["Licht: Halbschattig"],
#  "price":"€44,00",
#  "name":"Helmut",
#  "description":"Some description"}


def price_questions(name):
    return [
        f"Was kostet [{name}](product_name)?",
        f"Wie viel Euro kostet [{name}](product_name)?",
        f"Kannst du mir sagen, was [{name}](product_name) kosten soll?",
        f"Wie teuer ist [{name}](product_name)?",
    ]


def price_answer(name, price):
    return [
        f"{name} kostet {price}",
        f"{price}",
        f"Klar kann ich dir helfen: {name} ist für nur {price} erhältlich.",
    ]


if __name__ == "__main__":
    items = gen_bot.read_json_lines(crawl)
    nlu = gen_bot.new_nlu()

    gen_bot.add_lookup(nlu, "product", [item["name"] for item in items])

    pricing_intents = gen_bot.sample([
        q for item in items for q in price_questions(item["name"])
    ], num=30)
    gen_bot.add_intent(nlu, "pricing", pricing_intents)

    gen_bot.export_yaml(nlu, "pilea_perge_nlu.yml")
    print("Exported NLU data.")
