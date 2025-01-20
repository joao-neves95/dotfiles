from typing import Iterable

from nevespy import lists

import helpers

def extract_credit_statement_table_rows(sub_pages: Iterable[str]) -> Iterable[str]:
    all_movements = []

    for page in sub_pages:
        table_start_idx_inclusive = helpers.find_and_increment_idx(
            page, 0, "Valor Descritivo Rede Débito Crédito"
        )

        if table_start_idx_inclusive == -1:
            # This is a page without a table.
            continue

        table_start_idx_inclusive = helpers.find_and_increment_idx(
            page, table_start_idx_inclusive, "\n"
        )

        table_end_idx_exclusive = len(page)

        page_movements = page[table_start_idx_inclusive:table_end_idx_exclusive]
        page_movements = helpers.split_str_by_re(
            page_movements, r"\n\d{4}/\d{2}/\d{2} "
        )
        page_movements = lists.replace_in_str_list(page_movements, "\n", " ")

        for i in range(0, len(page_movements), 2):
            transaction = page_movements[i].lstrip() + page_movements[i + 1]
            all_movements.append(transaction)
        # end for

    # end for

    return all_movements


# end def


def convert_activobank_credit_row_to_gnucash_csv_row(row: str) -> Iterable[str]:
    """
    Args:
        row (str):
        "yyyy/mm/dd yyyy/mm/dd This is the description 420.69 MB"
        "yyyy/mm/dd This is the description 420.69 VIS"
        "yyyy/mm/dd IMPOSTO DO SELO 0.02"
    """
    row_parts = row.split(" ")
    transaction_date = row_parts[0]

    descriptionStartInclusive = (
        2 if helpers.str_is_re(row_parts[1], r"\d{4}/\d{2}/\d{2}") else 1
    )
    hasNetwork = helpers.str_is_re(row_parts[-1], r"[A-Z]{2,}")
    descriptionEndExclusive = -2 if hasNetwork else -1

    description = " ".join(row_parts[descriptionStartInclusive:descriptionEndExclusive])

    movement_value = row_parts[descriptionEndExclusive]

    return [transaction_date, movement_value, description]


# end def
