from argparse import ArgumentParser
from datetime import datetime, timedelta
import json
import logging
import os
from operator import itemgetter
from pathlib import Path
import sqlite3
import urllib.request

import pandas as pd
import pytz


DB = Path(__file__).resolve().parent.parent.parent.joinpath("share/corona/corona.db")
URL = "https://raw.githubusercontent.com/tokyo-metropolitan-gov/covid19/development/data/daily_positive_detail.json"
LOGGER = logging.getLogger("tokyo-corona")


def parse_argument():
    parser = ArgumentParser("tokyo corona", description="Show latest information on patient of COVIT-19")

    parser.add_argument("--severity",
                        type=str,
                        choices=["DEBUG", "INFO", "WARNING", "ERROR", "FATAL"],
                        default="WARNING",
                        help="set log level")

    parser.add_argument("--days",
                        type=int,
                        default=7,
                        help="Day span to show information")

    parser.add_argument("-w",
                        type=int,
                        default=50,
                        help="Width of display stats")

    return parser.parse_args()


def initialize(cur):
    dml = """
        CREATE TABLE IF NOT EXISTS tokyo (
            diagnosed_date date primary key,
            count int,
            missing_count int,
            reported_count int,
            weekly_gain_ratio float,
            untracked_percent float,
            weekly_average_count int,
            weekly_average_untracked_count float,
            weekly_average_untracked_increse_percent float
        );
    """
    cur.execute(dml)


def last_update(cur):
    LOGGER.debug("Fetch latest update date from local database")
    query = """
        SELECT
            IFNULL(MAX(diagnosed_date), DATE("2000-01-01")) AS last_update
        FROM
            tokyo
    """
    cur.execute(query)
    return cur.fetchall()[0]["last_update"]


def fetch_latest_info_from_github(lu):
    LOGGER.debug("Fetch latest information from %s", URL)
    req = urllib.request.Request(URL)
    with urllib.request.urlopen(req) as res:
        data = json.loads(res.read().decode())["data"]

    update = list(filter(lambda x: x["diagnosed_date"] > lu, data))
    return pd.read_json(json.dumps(update), orient="records")


def fetch_latest_info_from_local(cur, days):
    LOGGER.debug("Fetch latest information from local DB")
    query = f"""
        SELECT
            *,
            CASE STRFTIME("%w", diagnosed_date)
                WHEN "0" THEN STRFTIME("%Y-%m-%d (Sun)", diagnosed_date)
                WHEN "1" THEN STRFTIME("%Y-%m-%d (Mon)", diagnosed_date)
                WHEN "2" THEN STRFTIME("%Y-%m-%d (Tue)", diagnosed_date)
                WHEN "3" THEN STRFTIME("%Y-%m-%d (Wed)", diagnosed_date)
                WHEN "4" THEN STRFTIME("%Y-%m-%d (Thr)", diagnosed_date)
                WHEN "5" THEN STRFTIME("%Y-%m-%d (Fri)", diagnosed_date)
                WHEN "6" THEN STRFTIME("%Y-%m-%d (Sat)", diagnosed_date)
            END display_date
        FROM
            tokyo
        WHERE
            diagnosed_date > (
                SELECT
                    DATE(MAX(diagnosed_date), "-{days} days")
                FROM
                    tokyo
            )
        ORDER BY
            diagnosed_date
    """
    cur.execute(query)
    return cur.fetchall()


def main(args):
    logging.basicConfig(level=getattr(logging, args.severity))

    if not DB.parent.exists():
        os.makedirs(DB.parent)

    # 感染者情報の更新
    with sqlite3.connect(DB) as conn:
        conn.row_factory = sqlite3.Row
        cur = conn.cursor()

        initialize(cur)
        lu = last_update(cur)

        # 毎日 20:00 頃に感染者情報が update される
        latest = datetime.now(tz=pytz.timezone("Asia/Tokyo")) - timedelta(hours=20)
        if latest.strftime("%Y-%m-%d") > lu:
            df = fetch_latest_info_from_github(lu)
            df.to_sql('tokyo', conn, if_exists="append", index=False)

    # データ取得
    with sqlite3.connect(DB) as conn:
        conn.row_factory = sqlite3.Row
        cur = conn.cursor()

        data = fetch_latest_info_from_local(cur, args.days)
        mx = max(map(int, map(itemgetter("count"), data)))
        digit = max(len(str(mx)), 5)
        print(f"{{:>16s}} | {{:>{digit}s}} | histgram".format("date", "count"))
        print("-+-".join(["-"*16, "-"*digit, "-"*args.w]))
        for row in data:
            ln = args.w * int(row["count"]) // mx
            print(f"{{0[display_date]}} | {{0[count]:>{digit}d}} | {{1}}".format(row, "*" * ln))


if __name__ == "__main__":
    args = parse_argument()
    main(args)
