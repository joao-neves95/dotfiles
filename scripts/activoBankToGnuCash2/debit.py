from typing import Iterable

from nevespy import lists

import helpers


def extract_debit_statement_table_rows(sub_pages: Iterable[str]) -> Iterable[str]:
    all_movements = []

    for page in sub_pages:
        table_start_idx_inclusive = helpers.find_and_increment_idx(
            page, 0, "SALDO INICIAL"
        )

        if table_start_idx_inclusive == -1:
            # Try second page:
            table_start_idx_inclusive = helpers.find_and_increment_idx(
                page, 0, "TRANSPORTE"
            )

            if table_start_idx_inclusive == -1:
                # This is a page without a table.
                continue

        table_start_idx_inclusive = helpers.find_and_increment_idx(
            page, table_start_idx_inclusive, "\n"
        )

        table_start_idx_inclusive += 1

        last_page_table_end = helpers.find_and_increment_idx(
            page, table_start_idx_inclusive, "A TRANSPORTAR"
        )

        if last_page_table_end == -1:
            last_page_table_end = helpers.find_and_increment_idx(
                page, table_start_idx_inclusive, "SALDO FINAL"
            )

            if last_page_table_end == -1:
                table_end_idx_exclusive = len(page)
            else:
                table_end_idx_exclusive = last_page_table_end
        else:
            table_end_idx_exclusive = last_page_table_end

        page_movements = lists.strip_str_list(
            page[table_start_idx_inclusive:table_end_idx_exclusive].split("\n")
        )

        # For some reason, ActivoBank adds a '\n' after the dates of the first row.
        page_movements[1] = page_movements[0] + " " + page_movements[1]
        page_movements = page_movements[1:]

        all_movements.extend(page_movements)
    # end for

    return all_movements


# end def


def convert_all_activobank_debit_rows_to_gnucash_csv_rows(
    all_rows: Iterable[str],
) -> Iterable[Iterable[str]]:
    csv_rows = []

    # There's no way to know if a debit transaction is a deposit or a withdrawal, so we need to keep track of the account value.
    # Unfortunately the first row will always be positive.
    previous_account_value = 0.0

    for row in all_rows:
        (parsed_rows, new_account_value) = (
            __convert_activobank_debit_row_to_gnucash_csv_row(
                row, previous_account_value
            )
        )

        csv_rows.append(parsed_rows)
        previous_account_value = new_account_value
    # end for

    return csv_rows


# end def


def __convert_activobank_debit_row_to_gnucash_csv_row(
    row: str, previous_account_value: float
) -> tuple[Iterable[str], float]:
    """
    Args:
        row (str): "mm.dd mm.dd This is the description 420.69 42 069.69"
    """
    row_parts = row.split(" ")
    move_date = str(helpers.get_current_year()) + "/" + row_parts[0].replace(".", "/")

    last_idx_of_description = len(row_parts)
    for row_part_from_end_index in reversed(range(0, len(row_parts))):
        last_idx_of_description = row_part_from_end_index
        row_part = row_parts[row_part_from_end_index]

        if "." not in row_part:
            if row_part.isdigit() and len(row_part) <= 3:
                continue
            else:
                break
        else:
            # E.g.: "420.69"
            # Check first and last characters only.
            if not row_part[0].isdigit() or not row_part[-1].isdigit():
                break
            else:
                continue
    # end for

    description = " ".join(row_parts[2 : last_idx_of_description + 1])

    transaction_value = ""
    transaction_value_len = 0
    for part in row_parts[last_idx_of_description + 1 :]:
        if "." in part:
            transaction_value += part.strip()
            transaction_value_len += 1
            # Break on the first decimal point found.
            break
        if part.isdigit():
            transaction_value += part.strip()
            transaction_value_len += 1
            continue
        else:
            break
    # end for

    new_account_value = float(
        "".join(row_parts[last_idx_of_description + 1 + transaction_value_len :])
    )
    account_value_delta = new_account_value - previous_account_value

    transaction_value = (
        ("-" + transaction_value)
        # This is because there's no way of knowing if the first transaction is a deposit or a withdrawal.
        if previous_account_value == 0
        and any(
            substring in description
            for substring in (
                "COMPRA",
                "TRF P/",
                "Pagamento",
                "PAG.",
                "DD ",
                "DDPT",
            )
        )
        else transaction_value if account_value_delta >= 0 else "-" + transaction_value
    )

    return ([move_date, transaction_value, description], new_account_value)


# end def
