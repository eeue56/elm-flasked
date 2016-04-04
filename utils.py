def collect_args(obj):
    i = 0
    items = []

    while True:
        key = '_{n}'.format(n=i)

        if key not in obj:
            break

        items.append(obj[key])

        i += 1

    return items
