#! /usr/bin/env python3

import sys


def parse_time_to_minutes(time_str):
    """Converts formats like HH:MM, HH.MM, Xd, XdHH:MM, or HH to total minutes."""
    # Normalize: lower case, remove spaces, change dot to colon
    time_str = time_str.lower().replace(" ", "").replace(".", ":")

    days = 0
    # Handle the 'd' for days
    if "d" in time_str:
        parts = time_str.split("d")
        days = int(parts[0]) if parts[0] else 0
        time_str = parts[1]

    # If the input was just "2d" with no hours/minutes
    if not time_str:
        return days * 24 * 60

    parts = time_str.split(":")
    hours = int(parts[0]) if parts[0] else 0
    minutes = int(parts[1]) if len(parts) > 1 else 0

    return (days * 24 * 60) + (hours * 60) + minutes


def format_minutes_to_time(total_minutes):
    """Converts total minutes back to [+/-]HH:MM format, including days if >= 24h."""
    is_negative = total_minutes < 0
    total_minutes = abs(total_minutes)

    days = total_minutes // (24 * 60)
    remaining_minutes = total_minutes % (24 * 60)

    hours = remaining_minutes // 60
    minutes = remaining_minutes % 60

    sign = "-" if is_negative else ""

    # Standard HH:MM format (e.g., 26:30)
    total_hours = total_minutes // 60
    standard_format = f"{sign}{total_hours}:{minutes:02d}"

    # If it's 24 hours or more, we'll show the 'days' format in parentheses for clarity
    if days > 0:
        day_format = f"{sign}{days}d {hours}:{minutes:02d}"
        return f"{standard_format}  ({day_format})"

    return standard_format


def evaluate_expression(expr):
    """Parses and calculates the math expression."""
    # Ensure operators are surrounded by spaces so we can split easily
    clean_expr = expr.replace("+", " + ").replace("-", " - ")
    tokens = clean_expr.split()

    if not tokens:
        return "0:00", 0

    total = 0
    current_operator = "+"

    for token in tokens:
        if token in ["+", "-"]:
            current_operator = token
        else:
            try:
                mins = parse_time_to_minutes(token)
                if current_operator == "+":
                    total += mins
                elif current_operator == "-":
                    total -= mins
            except ValueError:
                raise ValueError(f"'{token}' isn't a valid time format.")

    return format_minutes_to_time(total), total


def main():
    print("=== Advanced Interactive Hour Calculator ===")
    print("Supports: HH.MM dots, Xd (days), and 'Ans' for continuous math.")
    print("Examples:")
    print("  8.30 + 2.45")
    print("  1d 12.00 - 4.30")
    print("  Ans + 2")
    print("Type 'q' or 'quit' to exit.\n")

    ans_minutes = 0

    while True:
        try:
            user_input = input("Time> ").strip()

            if user_input.lower() in ["q", "quit", "exit"]:
                print("Goodbye!")
                break

            if not user_input:
                continue

            # If you just type "+ 2.30", assume you want to add to Ans
            if user_input.startswith("+") or user_input.startswith("-"):
                user_input = "Ans " + user_input

            # Convert the raw Ans minutes into a pure time string so it parses safely
            is_neg = ans_minutes < 0
            abs_mins = abs(ans_minutes)
            ans_pure_time = (
                f"{'-' if is_neg else ''}{abs_mins // 60}:{abs_mins % 60:02d}"
            )

            # Substitute 'Ans' (case-insensitive) with the pure time string
            expr_to_eval = user_input.lower().replace("ans", ans_pure_time)

            try:
                result_str, ans_minutes = evaluate_expression(expr_to_eval)
                print(f"Result: {result_str}\n")
            except ValueError as e:
                print(f"Error: {e}\n")

        except (KeyboardInterrupt, EOFError):
            print("\nGoodbye!")
            sys.exit(0)


if __name__ == "__main__":
    main()
